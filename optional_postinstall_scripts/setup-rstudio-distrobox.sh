#!/bin/bash

# Setup RStudio in Debian Testing Distrobox
# This script creates a distrobox container and installs RStudio

set -e  # Exit on any error

echo "Creating debian-testing distrobox..."
distrobox create --name debian-testing --image docker.io/library/debian:testing \
  --additional-flags "--env=DISPLAY --env=WAYLAND_DISPLAY --env=XDG_RUNTIME_DIR --env=PULSE_RUNTIME_PATH --volume=/tmp/.X11-unix:/tmp/.X11-unix:rw --volume=$XDG_RUNTIME_DIR:$XDG_RUNTIME_DIR:rw --device=/dev/dri"

echo "Entering debian-testing distrobox and installing RStudio..."
distrobox enter debian-testing -- bash -c '
  echo "Updating package lists..."
  sudo apt update

  echo "Installing R base and development packages..."
  sudo apt install -y r-base r-base-dev libnspr4 libnss3 libasound2t64 libcurl4-openssl-dev gcc-gfortran

  echo "Downloading RStudio..."
  wget -O rstudio-2023.12.1-402-amd64.deb https://download1.rstudio.org/electron/jammy/amd64/rstudio-2023.12.1-402-amd64.deb

  echo "Installing RStudio..."
  sudo dpkg -i rstudio-2023.12.1-402-amd64.deb

  echo "Fixing any dependency issues..."
  sudo apt-get install -f -y

  echo "RStudio installation completed successfully!"
  echo "You can now run RStudio with: distrobox enter debian-testing -- rstudio"
'

echo "Setup complete! To use RStudio, run:"
echo "distrobox enter debian-testing -- rstudio"
