#!/bin/bash

# Script to create desktop files for Outlook, Teams, GitHub, YouTube, and YouTube Music using zen-browser
# Author: Generated for Arch Linux with zen-browser
# GitHub: https://github.com/aragao/nix

set -e  # Exit on any error

echo "Creating desktop files for Outlook, Teams, GitHub, YouTube, and YouTube Music..."

# Create the applications directory if it doesn't exist
echo "Creating ~/.local/share/applications directory..."
mkdir -p ~/.local/share/applications

# Create Outlook desktop file
echo "Creating Outlook desktop file..."
cat > ~/.local/share/applications/outlook-zen.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Outlook
Comment=Open Outlook in Zen Browser
Exec=zen-browser --new-window https://outlook.office.com
Icon=mail-microsoft-outlook
Terminal=false
Categories=Network;Email;Office;
StartupWMClass=outlook
StartupNotify=true
EOF

# Create Teams desktop file
echo "Creating Teams desktop file..."
cat > ~/.local/share/applications/teams-zen.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Microsoft Teams
Comment=Open Teams in Zen Browser
Exec=zen-browser --new-window https://teams.microsoft.com
Icon=microsoft-teams
Terminal=false
Categories=Network;InstantMessaging;Office;
StartupWMClass=teams
StartupNotify=true
EOF

# Create GitHub desktop file
echo "Creating GitHub desktop file..."
cat > ~/.local/share/applications/github-zen.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=GitHub
Comment=Open GitHub in Zen Browser
Exec=zen-browser --new-window https://github.com
Icon=github
Terminal=false
Categories=Network;Development;
StartupWMClass=github
StartupNotify=true
EOF

# Create YouTube desktop file
echo "Creating YouTube desktop file..."
cat > ~/.local/share/applications/youtube-zen.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=YouTube
Comment=Open YouTube in Zen Browser
Exec=zen-browser --new-window https://youtube.com
Icon=youtube
Terminal=false
Categories=Network;Video;AudioVideo;
StartupWMClass=youtube
StartupNotify=true
EOF

# Create YouTube Music desktop file
echo "Creating YouTube Music desktop file..."
cat > ~/.local/share/applications/youtube-music-zen.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=YouTube Music
Comment=Open YouTube Music in Zen Browser
Exec=zen-browser --new-window https://music.youtube.com
Icon=youtube-music
Terminal=false
Categories=Network;Audio;AudioVideo;
StartupWMClass=youtube-music
StartupNotify=true
EOF

# Make the files executable
echo "Making desktop files executable..."
chmod +x ~/.local/share/applications/outlook-zen.desktop
chmod +x ~/.local/share/applications/teams-zen.desktop
chmod +x ~/.local/share/applications/github-zen.desktop
chmod +x ~/.local/share/applications/youtube-zen.desktop
chmod +x ~/.local/share/applications/youtube-music-zen.desktop

# Update the desktop database
echo "Updating desktop database..."
update-desktop-database ~/.local/share/applications

echo ""
echo "✅ Desktop files created successfully!"
echo ""
echo "Created files:"
echo "  - ~/.local/share/applications/outlook-zen.desktop"
echo "  - ~/.local/share/applications/teams-zen.desktop"
echo "  - ~/.local/share/applications/github-zen.desktop"
echo "  - ~/.local/share/applications/youtube-zen.desktop"
echo "  - ~/.local/share/applications/youtube-music-zen.desktop"
echo ""
echo "You should now see 'Outlook', 'Microsoft Teams', 'GitHub', 'YouTube', and 'YouTube Music' in your application menu."
echo "Each will open in a separate zen-browser window."
echo ""
echo "If the icons don't appear, you may need to log out and back in,"
echo "or restart your desktop environment."
