#!/bin/bash

# Install Flatpak Applications
# This script installs the specified Flatpak applications

set -e  # Exit on any error

# List of Flatpak applications to install
FLATPAKS=(
    "io.github.benini.scid"              # Shane's Chess Information Database
    "be.alexandervanhee.gradia"          # Gradia - gradient editor
    "com.github.xournalpp.xournalpp"    # Xournal++ - handwriting notetaking software
    "org.sqlitebrowser.sqlitebrowser"   # DB Browser for SQLite
    "org.kde.kmymoney"                   # KMyMoney - personal finance manager
)

echo "Installing Flatpak applications..."
echo "Applications to install: ${#FLATPAKS[@]}"
echo

# Install each Flatpak
for flatpak in "${FLATPAKS[@]}"; do
    echo "Installing $flatpak..."
    if flatpak install --user -y flathub "$flatpak"; then
        echo "✓ Successfully installed $flatpak"
    else
        echo "✗ Failed to install $flatpak"
    fi
    echo
done

echo "Flatpak installation complete!"
echo
echo "You can now launch these applications from your application menu or using:"
echo "flatpak run <app-id>"
echo
echo "Installed applications:"
for flatpak in "${FLATPAKS[@]}"; do
    echo "  - $flatpak"
done