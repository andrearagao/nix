#!/bin/bash

# Arch Linux Package Installation Script
# Generated from shell history analysis
# This script recreates the package configuration found in the user's system

set -e  # Exit on any error

echo "🚀 Starting Arch Linux package installation..."
echo "=============================================="

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

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

# Install essential packages (from pacman history)
echo ""
echo "📦 Installing packages from pacman history..."
pacman_packages=(
    "gum"                    # Terminal UI builder
    "qutebrowser"           # Web browser
    "speech-dispatcher"      # Speech synthesis
    "speech-dispatcher-utils" # Speech synthesis utilities
)

install_packages "${pacman_packages[@]}"

# Install AUR packages (from yay history and current system)
echo ""
echo "📦 Installing AUR packages from yay history..."
aur_packages=(
    "speed-dispatcher"       # Speed test dispatcher
    "zen-browser-bin"        # Zen browser
)

install_aur_packages "${aur_packages[@]}"

# Install additional AUR packages found in current system
echo ""
echo "📦 Installing additional AUR packages found in system..."
additional_aur_packages=(
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

install_aur_packages "${additional_aur_packages[@]}"

# Install development tools and utilities
echo ""
echo "🔧 Installing development tools and utilities..."
dev_packages=(
    "git"                    # Version control
    "base-devel"             # Base development tools
    "cmake"                  # Build system
    "ninja"                  # Build system
    "pkg-config"             # Package configuration
)

install_packages "${dev_packages[@]}"

# Install multimedia and graphics
echo ""
echo "🎨 Installing multimedia and graphics packages..."
multimedia_packages=(
    "ffmpeg"                 # Multimedia framework
    "imagemagick"            # Image manipulation
    "gimp"                   # Image editor
    "inkscape"               # Vector graphics editor
)

install_packages "${multimedia_packages[@]}"

# Install system utilities
echo ""
echo "⚙️ Installing system utilities..."
system_packages=(
    "htop"                   # Process viewer
    "neofetch"               # System info
    "tree"                   # Directory tree
    "ripgrep"                # Fast grep
    "fd"                     # Fast find
    "bat"                    # Better cat
    "exa"                    # Better ls
    "fzf"                    # Fuzzy finder
)

install_packages "${system_packages[@]}"

# Install networking tools
echo ""
echo "🌐 Installing networking tools..."
network_packages=(
    "wget"                   # Web downloader
    "curl"                   # Web client
    "nmap"                   # Network scanner
    "net-tools"              # Network utilities
)

install_packages "${network_packages[@]}"

# Clean up package cache
echo ""
echo "🧹 Cleaning up package cache..."
sudo pacman -Sc --noconfirm

# Update package database
echo ""
echo "🔄 Updating package database..."
sudo pacman -Fy

echo ""
echo "🎉 Package installation completed!"
echo "=============================================="
echo ""
echo "📋 Summary of installed packages:"
echo "   - Official packages: ${#pacman_packages[@]} packages"
echo "   - AUR packages: ${#aur_packages[@]} packages"
echo "   - Additional AUR packages: ${#additional_aur_packages[@]} packages"
echo "   - Development tools: ${#dev_packages[@]} packages"
echo "   - Multimedia packages: ${#multimedia_packages[@]} packages"
echo "   - System utilities: ${#system_packages[@]} packages"
echo "   - Networking tools: ${#network_packages[@]} packages"
echo ""
echo "💡 You can now run: pacman -Q to see all installed packages"
echo "💡 For AUR packages: pacman -Qm"
echo ""
echo "�� System is ready!"

