#!/bin/bash

# Apply Chezmoi Dotfiles
# This script initializes and applies dotfiles from GitHub repository

set -e  # Exit on any error

DOTFILES_REPO="https://github.com/whelanh/dotfiles"

echo "Setting up chezmoi dotfiles from $DOTFILES_REPO"
echo

# Check if chezmoi is installed
if ! command -v chezmoi &> /dev/null; then
    echo "Error: chezmoi is not installed."
    echo "Please install chezmoi first:"
    echo "  curl -fsLS get.chezmoi.io | sh"
    echo "  or use your package manager"
    exit 1
fi

echo "Chezmoi version:"
chezmoi --version
echo

# Check if chezmoi is already initialized
if [ -d "$HOME/.local/share/chezmoi" ]; then
    echo "Chezmoi is already initialized."
    echo "Current source directory: $HOME/.local/share/chezmoi"
    echo
    
    read -p "Do you want to reinitialize with the new repository? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Removing existing chezmoi source directory..."
        rm -rf "$HOME/.local/share/chezmoi"
    else
        echo "Keeping existing configuration. Updating instead..."
        cd "$HOME/.local/share/chezmoi"
        git pull origin main || git pull origin master
        echo "Repository updated. Applying changes..."
        chezmoi apply
        echo "Dotfiles applied successfully!"
        exit 0
    fi
fi

echo "Initializing chezmoi with repository: $DOTFILES_REPO"
chezmoi init "$DOTFILES_REPO"

echo "Repository initialized. Reviewing changes..."
echo "The following files will be managed by chezmoi:"
chezmoi diff

echo
read -p "Do you want to apply these dotfiles? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Applying dotfiles..."
    chezmoi apply
    echo
    echo "✓ Dotfiles applied successfully!"
    echo
    echo "Chezmoi has been set up with your dotfiles."
    echo "Source directory: $HOME/.local/share/chezmoi"
    echo
    echo "Common chezmoi commands:"
    echo "  chezmoi status    - Show status of managed files"
    echo "  chezmoi diff      - Show differences between source and target"
    echo "  chezmoi apply     - Apply changes from source to target"
    echo "  chezmoi update    - Pull and apply changes from repository"
    echo "  chezmoi cd        - Change to the source directory"
else
    echo "Dotfiles were not applied."
    echo "You can review the changes with: chezmoi diff"
    echo "And apply them later with: chezmoi apply"
fi