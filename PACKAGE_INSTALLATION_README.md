# Arch Linux Package Installation Scripts

This directory contains scripts to reproduce the exact package configuration found on this Arch Linux machine.

## Files Overview

### 1. `install_all_packages.sh` - Main Installation Script

- **Purpose**: Installs all packages currently installed on this system
- **Contains**: 776 official packages + 11 AUR packages = 787 total packages
- **Usage**: `./install_all_packages.sh`

### 2. `generate_package_list.sh` - Package List Generator

- **Purpose**: Dynamically generates a current package list from the system
- **Output**: Creates timestamped files like `current_packages_20250816_192230.txt`
- **Usage**: `./generate_package_list.sh`

### 3. `package_list.txt` - Static Package Reference

- **Purpose**: Human-readable reference of all installed packages
- **Content**: Organized by package type (official vs AUR)

## How to Use

### For System Reproduction

1. **Fresh Arch Linux Installation**: Run `./install_all_packages.sh` to install all packages
2. **Package Verification**: Use `pacman -Q` to see all installed packages
3. **AUR Package Check**: Use `pacman -Qm` to see AUR packages

### For Package Management

1. **Generate Current List**: Run `./generate_package_list.sh` to get current state
2. **Compare Packages**: Compare generated files to track changes over time
3. **Backup Configuration**: Keep generated package lists as system snapshots

## Prerequisites

- Arch Linux system
- `sudo` access
- `yay` AUR helper (will be installed if missing)
- Internet connection for package downloads

## Package Categories

### Official Packages (776 packages)

- **System**: base, systemd, linux-aarch64, etc.
- **Development**: gcc, clang, python, rust, nodejs, etc.
- **Desktop**: hyprland, wayland, gtk, qt, etc.
- **Multimedia**: ffmpeg, mpv, imagemagick, etc.
- **Utilities**: git, docker, neovim, etc.

### AUR Packages (11 packages)

- **Browsers**: brave-bin, zen-browser-bin
- **Development**: k3s-bin, lazydocker-bin
- **Tools**: pandoc-bin, python-terminaltexteffects
- **Fonts**: ttf-ia-writer
- **System**: tzupdate, ufw-docker, walker-bin, wl-screenrec
- **Themes**: yaru-icon-theme

## Notes

- The script includes error handling and will stop on package installation failures
- AUR packages require `yay` to be installed first
- Some packages may have dependencies that are automatically resolved
- The script updates the system before installing packages
- Package cache is cleaned after installation

## Troubleshooting

- **Permission Issues**: Ensure you have sudo access
- **AUR Failures**: Check if `yay` is properly installed
- **Network Issues**: Verify internet connectivity
- **Package Conflicts**: Some packages may conflict; resolve manually if needed

## Maintenance

- Run `./generate_package_list.sh` periodically to track package changes
- Update the main script when adding/removing packages
- Keep backup copies of package lists for system recovery
