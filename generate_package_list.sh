#!/bin/bash

# Generate current package list from system
# This script creates a comprehensive list of all installed packages

echo "📦 Generating current package list..."
echo "====================================="

# Create output file
output_file="current_packages_$(date +%Y%m%d_%H%M%S).txt"

echo "# Complete Package List for Arch Linux System" > "$output_file"
echo "# Generated on $(date)" >> "$output_file"
echo "# Total packages: $(pacman -Q | wc -l)" >> "$output_file"
echo "" >> "$output_file"

# Official packages
echo "## Official Packages (pacman -Q)" >> "$output_file"
pacman -Q | cut -d' ' -f1 | tr '\n' ' ' >> "$output_file"
echo "" >> "$output_file"
echo "" >> "$output_file"

# AUR packages
echo "## AUR Packages (pacman -Qm)" >> "$output_file"
pacman -Qm | cut -d' ' -f1 | tr '\n' ' ' >> "$output_file"
echo "" >> "$output_file"
echo "" >> "$output_file"

# Package counts
echo "## Package Counts" >> "$output_file"
echo "Official packages: $(pacman -Q | wc -l)" >> "$output_file"
echo "AUR packages: $(pacman -Qm | wc -l)" >> "$output_file"
echo "Total packages: $(( $(pacman -Q | wc -l) + $(pacman -Qm | wc -l) ))" >> "$output_file"

echo "✅ Package list saved to: $output_file"
echo "📊 Summary:"
echo "   - Official packages: $(pacman -Q | wc -l)"
echo "   - AUR packages: $(pacman -Qm | wc -l)"
echo "   - Total packages: $(( $(pacman -Q | wc -l) + $(pacman -Qm | wc -l) ))"
