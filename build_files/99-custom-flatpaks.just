# Custom Flatpak installations for Aurora KDE Git DX
# This file contains ujust recipes for managing custom Flatpak applications

# Development and productivity Flatpaks list - defined once and used by all recipes
FLATPAKS := '''
io.github.benini.scid
be.alexandervanhee.gradia
com.github.xournalpp.xournalpp
org.sqlitebrowser.sqlitebrowser
org.kde.kmymoney
org.kde.isoimagewriter
com.github.zocker_160.SyncThingy  
'''

# Install development and productivity Flatpaks
install-dev-flatpaks:
    #!/usr/bin/env bash
    echo "Installing development and productivity Flatpaks..."
    
    # Convert the FLATPAKS string into an array
    IFS=$'\n' read -rd '' -a FLATPAKS <<< "{{ FLATPAKS }}"
    
    # Remove empty elements (if any)
    FLATPAKS=("${FLATPAKS[@]//[[:space:]]/}")
    FLATPAKS=("${FLATPAKS[@]//^$/}")
    
    # Application descriptions
    declare -A DESCRIPTIONS=(
        ["io.github.benini.scid"]="Shane's Chess Information Database"
        ["be.alexandervanhee.gradia"]="Gradia - gradient editor"
        ["com.github.xournalpp.xournalpp"]="Xournal++ - handwriting notetaking software"
        ["org.sqlitebrowser.sqlitebrowser"]="DB Browser for SQLite"
        ["org.kde.kmymoney"]="KMyMoney - personal finance manager"
        ["org.kde.isoimagewriter"]="ISO Image Writer - writing images to USB"
        ["com.github.zocker_160.SyncThingy"]="SyncThingy - for file sharing"
    )
    
    echo "The following Flatpaks will be installed:"
    for flatpak in "${FLATPAKS[@]}"; do
        if [[ -n "$flatpak" ]]; then
            echo "  • $flatpak - ${DESCRIPTIONS[$flatpak]}"
        fi
    done
    echo
    
    # Add flathub remote if not already added (user scope)
    if ! flatpak remote-list --user | grep -q flathub; then
        echo "Adding Flathub repository..."
        flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    fi
    
    # Install each Flatpak
    for flatpak in "${FLATPAKS[@]}"; do
        if [[ -n "$flatpak" ]]; then
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
        fi
    done
    
    echo
    echo "Flatpak installation complete!"
    echo "You can launch these applications from your application menu."

# Remove all development Flatpaks
remove-dev-flatpaks:
    #!/usr/bin/env bash
    echo "Removing development and productivity Flatpaks..."
    
    # Convert the FLATPAKS string into an array
    IFS=$'\n' read -rd '' -a FLATPAKS <<< "{{ FLATPAKS }}"
    
    # Remove empty elements (if any)
    FLATPAKS=("${FLATPAKS[@]//[[:space:]]/}")
    FLATPAKS=("${FLATPAKS[@]//^$/}")
    
    for flatpak in "${FLATPAKS[@]}"; do
        if [[ -n "$flatpak" ]]; then
            if flatpak list --user | grep -q "$flatpak"; then
                echo "Removing $flatpak..."
                flatpak uninstall --user -y "$flatpak"
            else
                echo "✓ $flatpak is not installed"
            fi
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
        
        # Convert the FLATPAKS string into an array
        IFS=$'\n' read -rd '' -a FLATPAKS <<< "{{ FLATPAKS }}"
        
        # Remove empty elements (if any)
        FLATPAKS=("${FLATPAKS[@]//[[:space:]]/}")
        FLATPAKS=("${FLATPAKS[@]//^$/}")
        
        # Add flathub remote if not already added (user scope)
        if ! flatpak remote-list --user | grep -q flathub; then
            echo "Adding Flathub repository..."
            flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        fi
        
        # Install each Flatpak quietly
        for flatpak in "${FLATPAKS[@]}"; do
            if [[ -n "$flatpak" ]]; then
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
    echo "Development Flatpaks status:"
    
    # Convert the FLATPAKS string into an array
    IFS=$'\n' read -rd '' -a FLATPAKS <<< "{{ FLATPAKS }}"
    
    # Remove empty elements (if any)
    FLATPAKS=("${FLATPAKS[@]//[[:space:]]/}")
    FLATPAKS=("${FLATPAKS[@]//^$/}")
    
    # Application descriptions
    declare -A DESCRIPTIONS=(
        ["io.github.benini.scid"]="Shane's Chess Information Database"
        ["be.alexandervanhee.gradia"]="Gradia - gradient editor"
        ["com.github.xournalpp.xournalpp"]="Xournal++ - handwriting notetaking software"
        ["org.sqlitebrowser.sqlitebrowser"]="DB Browser for SQLite"
        ["org.kde.kmymoney"]="KMyMoney - personal finance manager"
        ["org.kde.isoimagewriter"]="ISO Image Writer - writing images to USB"
    )
    
    for flatpak in "${FLATPAKS[@]}"; do
        if [[ -n "$flatpak" ]]; then
            if flatpak list --user | grep -q "$flatpak"; then
                echo "  ✓ $flatpak - ${DESCRIPTIONS[$flatpak]}"
            else
                echo "  ✗ $flatpak - ${DESCRIPTIONS[$flatpak]} (not installed)"
            fi
        fi
    done
