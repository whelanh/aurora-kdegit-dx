# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

This is a bootc (bootable container) image template for creating custom Aurora KDE development environments. The project builds two customized container image variants based on Aurora DX that include KDE Plasma unstable builds, development tools, and a complete KDE development stack:

- **Aurora KDE DX**: Standard variant based on `aurora-dx:latest`, published as `aurora-kdegit-dx:latest`
- **Aurora KDE DX NVIDIA**: NVIDIA-optimized variant based on `aurora-dx-nvidia:latest`, published as `aurora-kdegit-dx-nvidia:latest`

## Architecture

### Core Components

- **Containerfile**: Defines the container build process using build args for base image selection
- **build_files/build.sh**: Main build script that installs KDE unstable packages, development dependencies, tools, and R/RStudio via COPR
- **build_files/99-custom-flatpaks.just**: Custom ujust recipes for automatic Flatpak application management
- **build_files/aurora-kdegit-dx-setup.service**: Systemd user service for automatic first-login setup
- **Justfile**: Command runner with comprehensive build, test, and VM management recipes for both variants
- **disk_config/**: Configuration files for building bootable disk images (QCOW2, RAW, ISO)
- **optional_postinstall_scripts/**: Optional post-install utilities (currently includes Flatpak installer)

### Build Process

1. **Base Images**: Uses Aurora DX variants as foundation:
   - Standard: `ghcr.io/ublue-os/aurora-dx:latest`
   - NVIDIA: `ghcr.io/ublue-os/aurora-dx-nvidia:latest`
2. **Package Management**: Enables unstable KDE COPRs (`solopasha/plasma-unstable`, `solopasha/kde-gear-unstable`)
3. **R/RStudio Setup**: Enables `iucar/rstudio` COPR and installs `R`, `R-devel`, `rstudio`, and `gcc-gfortran`
4. **Development Stack**: Installs KDE build dependencies, development tools, and kde-builder
5. **Flatpak Management**: Installs ujust recipes and systemd service for automatic Flatpak application management
6. **System Services**: Enables podman socket, waydroid services, and automatic setup service

## Common Development Commands

### Building the Container Image

Build the standard DX variant:
```bash
just build
```

Build the NVIDIA variant:
```bash
just build-nvidia
```

Build both variants:
```bash
just build-all
```

Build with specific variant, name and tag:
```bash
just build aurora-kdegit-dx latest dx
just build aurora-kdegit-dx latest nvidia
```

### Creating Bootable Images

Build a QCOW2 VM image:
```bash
just build-qcow2
```

Build an ISO installer:
```bash
just build-iso
```

Build a RAW disk image:
```bash
just build-raw
```

Rebuild any image type (rebuilds container first):
```bash
just rebuild-qcow2
just rebuild-iso  
just rebuild-raw
```

### Running and Testing

Run a VM from QCOW2 image:
```bash
just run-vm-qcow2
```

Run VM with systemd-vmspawn:
```bash
just spawn-vm
```

Run with custom settings:
```bash
just spawn-vm rebuild="1" type="qcow2" ram="8G"
```

### Code Quality

Check Just syntax:
```bash
just check
```

Fix Just formatting:
```bash
just fix
```

Lint shell scripts:
```bash
just lint
```

Format shell scripts:
```bash
just format
```

Clean build artifacts:
```bash
just clean
```

## Development Environment

### KDE Development Stack

The build includes:
- **kde-builder**: KDE's build system for compiling KDE software from source
- **KDevelop**: Full-featured KDE IDE
- **Complete KDE dependencies**: All packages needed for KDE development
- **Unstable KDE packages**: Latest KDE Plasma and KDE Gear from COPRs

### Additional Tools

- **Development**: neovim, zsh, git, clang-devel
- **Data Science**: R, R-devel, RStudio, gcc-gfortran (via `iucar/rstudio` COPR)
- **Flatpak Management**: Automatic ujust-based installation of development Flatpaks on first login
- **Containerization**: podman with socket enabled
- **Android**: waydroid for Android app development
- **Build tools**: flatpak-builder for creating Flatpak applications

## Automatic Flatpak Management

The image includes custom ujust recipes that automatically install the following Flatpak applications on first user login:

- **io.github.benini.scid**: Shane's Chess Information Database
- **be.alexandervanhee.gradia**: Gradia - gradient editor
- **com.github.xournalpp.xournalpp**: Xournal++ - handwriting notetaking software
- **org.sqlitebrowser.sqlitebrowser**: DB Browser for SQLite
- **org.kde.kmymoney**: KMyMoney - personal finance manager
- **org.kde.isoimagewriter**: ISO Image Writer - writing images to USB

### Available ujust Commands

- `ujust auto-setup-flatpaks` - Run automatic setup (executed automatically on first login)
- `ujust install-dev-flatpaks` - Manually install all development Flatpaks
- `ujust remove-dev-flatpaks` - Remove all development Flatpaks (preserves user data)
- `ujust list-dev-flatpaks` - Check installation status of development Flatpaks

## Optional Post-Install Scripts

> Note: Flatpak management has been migrated to ujust recipes with automatic setup. Earlier optional scripts (chezmoi dotfiles and RStudio in Distrobox) were removed. The `optional_postinstall_scripts/` directory may be removed in future updates.

## Configuration Files

### Image Variants

- **disk.toml**: Standard VM disk configuration (20 GiB minimum)
- **iso-kde.toml**: KDE-specific ISO installer configuration  
- **iso-gnome.toml**: GNOME-specific ISO installer configuration

### Build Configuration

Environment variables in Justfile:
- `IMAGE_NAME`: Container image name (default: "aurora-kdegit-dx")
- `DEFAULT_TAG`: Default image tag (default: "latest") 
- `BIB_IMAGE`: Bootc Image Builder image to use
- `BASE_IMAGE_DX`: Aurora DX base image (default: "ghcr.io/ublue-os/aurora-dx:latest")
- `BASE_IMAGE_NVIDIA`: Aurora DX NVIDIA base image (default: "ghcr.io/ublue-os/aurora-dx-nvidia:latest")

## Switching to Your Custom Image

After building and publishing your image:

```bash
sudo bootc switch ghcr.io/<username>/<image_name>
```

## Important Notes

- Container signing is enabled - ensure `cosign.key` is never committed to git
- Public signing key in `cosign.pub` has been updated to current maintainer's key
- Base image can be changed by modifying the `BASE_IMAGE` build arg in Containerfile
- COPR repositories provide bleeding-edge KDE packages with priority=1
- Build artifacts are output to `output/` directory
- VM images use QEMU with hardware acceleration when available
- GitHub Actions builds both variants automatically using matrix strategy; concurrency grouping adjusted to prevent overlapping runs
