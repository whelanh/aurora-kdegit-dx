# Custom Flatpak installations for Aurora KDE Git DX
# This file contains ujust recipes for managing custom Flatpak applications

# Install development and productivity Flatpaks
install-dev-flatpaks:
    #!/usr/bin/env bash
    echo "Installing development and productivity Flatpaks..."
    
    # List of Flatpaks to install
    FLATPAKS=(
        "io.github.benini.scid"              # Shane's Chess Information Database
        "be.alexandervanhee.gradia"          # Gradia - gradient editor  
        "com.github.xournalpp.xournalpp"    # Xournal++ - handwriting notetaking software
        "org.sqlitebrowser.sqlitebrowser"   # DB Browser for SQLite
        "org.kde.kmymoney"                   # KMyMoney - personal finance manager
        "org.kde.isoimagewriter"             # ISO Image Writer - writing images to USB
    )
    
    echo "The following Flatpaks will be installed:"
    printf '  • %s\n' "${FLATPAKS[@]}"
    echo
    
    # Add flathub remote if not already added (user scope)
    if ! flatpak remote-list --user | grep -q flathub; then
        echo "Adding Flathub repository..."
        flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    fi
    
    # Install each Flatpak
    for flatpak in "${FLATPAKS[@]}"; do
        if flatpak list --user | grep -q "$flatpak"; then
            echo "✓ $flatpak is already installed"
        else
            echo "Installing $flatpak..."
            if flatpak install --user -y flathub "$flatpak"; then
                echo "✓ Successfully installed $flatpak"
            else
                echo "✗ Failed to install $flatpak"
            fi
        fi
    done
    
    echo
    echo "Flatpak installation complete!"
    echo "You can launch these applications from your application menu."

# Remove all development Flatpaks
remove-dev-flatpaks:
    #!/usr/bin/env bash
    echo "Removing development and productivity Flatpaks..."
    
    FLATPAKS=(
        "io.github.benini.scid"
        "be.alexandervanhee.gradia"  
        "com.github.xournalpp.xournalpp"
        "org.sqlitebrowser.sqlitebrowser"
        "org.kde.kmymoney"
        "org.kde.isoimagewriter"
    )
    
    for flatpak in "${FLATPAKS[@]}"; do
        if flatpak list --user | grep -q "$flatpak"; then
            echo "Removing $flatpak..."
            flatpak uninstall --user -y "$flatpak"
        else
            echo "✓ $flatpak is not installed"
        fi
    done
    
    echo "Cleanup complete!"

# Auto-setup: Install Flatpaks automatically on first run
auto-setup-flatpaks:
    #!/usr/bin/env bash
    SETUP_FILE="$HOME/.config/aurora-kdegit-dx-setup-done"
    
    if [ ! -f "$SETUP_FILE" ]; then
        echo "🚀 Aurora KDE Git DX: First-time setup"
        echo "Installing development Flatpaks automatically..."
        
        # List of Flatpaks to install (same as install-dev-flatpaks)
        FLATPAKS=(
            "io.github.benini.scid"              # Shane's Chess Information Database
            "be.alexandervanhee.gradia"          # Gradia - gradient editor  
            "com.github.xournalpp.xournalpp"    # Xournal++ - handwriting notetaking software
            "org.sqlitebrowser.sqlitebrowser"   # DB Browser for SQLite
            "org.kde.kmymoney"                   # KMyMoney - personal finance manager
            "org.kde.isoimagewriter"             # ISO Image Writer - writing images to USB
        )
        
        # Add flathub remote if not already added (user scope)
        if ! flatpak remote-list --user | grep -q flathub; then
            echo "Adding Flathub repository..."
            flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        fi
        
        # Install each Flatpak quietly
        for flatpak in "${FLATPAKS[@]}"; do
            if flatpak list --user | grep -q "$flatpak"; then
                echo "✓ $flatpak is already installed"
            else
                echo "Installing $flatpak..."
                if flatpak install --user -y flathub "$flatpak" >/dev/null 2>&1; then
                    echo "✓ Successfully installed $flatpak"
                else
                    echo "✗ Failed to install $flatpak"
                fi
            fi
        done
        
        # Mark setup as complete
        mkdir -p "$(dirname "$SETUP_FILE")"
        echo "$(date): Flatpaks installed automatically" > "$SETUP_FILE"
        echo
        echo "✅ First-time setup complete!"
        echo "   Run 'ujust install-dev-flatpaks' to reinstall if needed"
        echo "   Run 'ujust remove-dev-flatpaks' to remove all these apps"
    else
        echo "✓ Development Flatpaks already set up"
        echo "  Run 'ujust install-dev-flatpaks' to reinstall if needed"
    fi

# List installed development Flatpaks
list-dev-flatpaks:
    #!/usr/bin/env bash
    echo "Development Flatpaks installed:"
    FLATPAKS=(
        "io.github.benini.scid"
        "be.alexandervanhee.gradia"
        "com.github.xournalpp.xournalpp"
        "org.sqlitebrowser.sqlitebrowser"
        "org.kde.kmymoney"
        "org.kde.isoimagewriter"
    )
    
    for flatpak in "${FLATPAKS[@]}"; do
        if flatpak list --user | grep -q "$flatpak"; then
            echo "  ✓ $flatpak"
        else
            echo "  ✗ $flatpak (not installed)"
        fi
    done