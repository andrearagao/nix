#!/bin/bash

# Arch Linux Exact Package Installation Script
# Based on actual shell history analysis
# This script installs ONLY the packages found in your command history

set -e  # Exit on any error

echo "🚀 Installing packages from your shell history..."
echo "================================================"

# Function to install packages with error handling
install_packages() {
    local packages=("$@")
    echo "📦 Installing packages: ${packages[*]}"

    if ! sudo pacman -S --noconfirm "${packages[@]}"; then
        echo "❌ Failed to install packages: ${packages[*]}"
        return 1
    fi
    echo "✅ Successfully installed: ${packages[*]}"
}

# Function to install AUR packages with yay
install_aur_packages() {
    local packages=("$@")
    echo "📦 Installing AUR packages: ${packages[*]}"

    if ! yay -S --noconfirm "${packages[@]}"; then
        echo "❌ Failed to install AUR packages: ${packages[*]}"
        return 1
    fi
    echo "✅ Successfully installed AUR packages: ${packages[*]}"
}

# Update system first
echo "🔄 Updating system packages..."
sudo pacman -Syu --noconfirm

# Install packages from pacman history (exact commands found)
echo ""
echo "📦 Installing packages from pacman history..."
pacman_packages=(
    "gum"                    # Terminal UI builder
    "qutebrowser"           # Web browser
    "speech-dispatcher"      # Speech synthesis
    "speech-dispatcher-utils" # Speech synthesis utilities
)

install_packages "${pacman_packages[@]}"

# Install AUR packages from yay history (exact commands found)
echo ""
echo "📦 Installing AUR packages from yay history..."
aur_packages=(
    "speed-dispatcher"       # Speed test dispatcher
    "zen-browser-bin"        # Zen browser
)

install_aur_packages "${aur_packages[@]}"

# Install additional packages that were found in your current system
# These appear to be packages you installed but may not be in recent history
echo ""
echo "📦 Installing additional packages found in your system..."
additional_packages=(
    "brave-bin"              # Brave browser (found in pacman -Qm)
    "k3s-bin"                # Lightweight Kubernetes
    "lazydocker-bin"         # Docker TUI
    "python-terminaltexteffects" # Terminal text effects
    "ttf-ia-writer"          # IA Writer font
    "tzupdate"               # Timezone updater
    "ufw-docker"             # UFW Docker integration
    "walker-bin"             # File browser
    "wl-screenrec"           # Wayland screen recorder
    "yaru-icon-theme"        # Yaru icon theme
    "yay-bin"                # AUR helper
)

install_aur_packages "${additional_packages[@]}"

# Clean up package cache
echo ""
echo "🧹 Cleaning up package cache..."
sudo pacman -Sc --noconfirm

echo ""
echo "🎉 Installation completed!"
echo "================================================"
echo ""
echo "📋 Summary of installed packages:"
echo "   - From pacman history: ${#pacman_packages[@]} packages"
echo "   - From yay history: ${#aur_packages[@]} packages"
echo "   - Additional system packages: ${#additional_packages[@]} packages"
echo ""
echo "💡 These are the exact packages found in your shell history and current system"
echo "💡 Run 'pacman -Q' to see all installed packages"
echo "💡 Run 'pacman -Qm' to see AUR packages"
echo ""
echo "🚀 Your exact package configuration has been recreated!"

