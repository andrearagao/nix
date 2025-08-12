#!/usr/bin/env bash

# Home Manager with Nix setup script
set -e

# Parse command line arguments
LIVE_MODE=false
if [[ "$1" == "--live" || "$1" == "-l" ]]; then
    LIVE_MODE=true
fi

if [[ "$LIVE_MODE" == "true" ]]; then
    echo "🔄 Starting Home Manager Live Mode..."
    echo "Monitoring nix files for changes..."
else
    echo "🏠 Setting up Home Manager with Nix..."
fi
echo ""

# Check if nix is installed
if ! command -v nix &> /dev/null; then
    echo "❌ Error: Nix is not installed."
    echo "Please install Nix first with:"
    echo "  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install"
    exit 1
fi

echo "✅ Nix is installed"

# Check if experimental features are available (will be enabled by Home Manager)
echo "ℹ️  Experimental features (nix-command flakes) will be enabled by Home Manager"

# Check if home-manager is available
if ! command -v home-manager &> /dev/null; then
    echo "📦 Home Manager not found, will use nix run..."
    HM_CMD="nix run home-manager/master --"
else
    echo "✅ Home Manager found"
    HM_CMD="home-manager"
fi

# Function to apply home manager configuration
apply_config() {
    echo "📝 Applying configuration..."
    if $HM_CMD switch --flake .#aragao -b backup; then
        echo "✅ Home Manager configuration applied successfully!"
        return 0
    else
        echo "❌ Failed to apply Home Manager configuration"
        return 1
    fi
}

# Update flake inputs to latest versions
echo "🔄 Updating flake inputs to latest versions..."
if nix flake update; then
    echo "✅ Flake inputs updated"
else
    echo "⚠️  Failed to update flake inputs, continuing with existing versions..."
fi

# Validate flake configuration
echo "🔍 Validating flake configuration..."
if ! nix flake check 2>/dev/null; then
    echo "❌ Flake validation failed. Please check your configuration."
    exit 1
fi
echo "✅ Flake configuration is valid"

# Apply Home Manager configuration
echo ""
echo "🚀 Applying Home Manager configuration..."

# Apply the configuration
if apply_config; then
    # Verify that Home Manager nix settings are applied
    echo "🔍 Verifying nix experimental features are enabled..."
    if nix --help | grep -q "flakes" 2>/dev/null; then
        echo "✅ Nix experimental features are working"
    else
        echo "⚠️  Nix experimental features may not be fully applied"
        echo "   You may need to restart your shell or terminal"
    fi
    
    # Check current shell and conditionally change to fish
    CURRENT_SHELL=$(basename "$SHELL")
    FISH_PATH="$HOME/.nix-profile/bin/fish"
    
    if [ "$CURRENT_SHELL" != "fish" ] && [ -x "$FISH_PATH" ]; then
        echo ""
        echo "🐟 Your current shell is $CURRENT_SHELL"
        read -p "Would you like to set fish as your default shell? (Y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Nn]$ ]]; then
            echo "Keeping $CURRENT_SHELL as default shell"
        else
            echo "Setting fish as default shell..."
            
            # Add fish to /etc/shells if not already there
            if ! grep -q "$FISH_PATH" /etc/shells 2>/dev/null; then
                echo "Adding $FISH_PATH to /etc/shells (requires sudo)..."
                echo "$FISH_PATH" | sudo tee -a /etc/shells > /dev/null
            fi
            
            # Change user's default shell
            if chsh -s "$FISH_PATH" 2>/dev/null; then
                echo "✅ Default shell changed to fish"
            else
                echo "⚠️  Could not change default shell automatically"
                echo "   Please run: chsh -s $FISH_PATH"
            fi
        fi
    elif [ "$CURRENT_SHELL" = "fish" ]; then
        echo "✅ Fish is already your default shell"
    elif [ ! -x "$FISH_PATH" ]; then
        echo "⚠️  Fish executable not found at expected location"
        echo "   You may need to restart your terminal and try: chsh -s \$(which fish)"
    fi
    
    echo ""
    echo "🎉 Setup complete!"
    echo ""
    echo "Next steps:"
    echo "  1. Update your Git email in home.nix if needed"
    echo "  2. Log out and log back in (or restart terminal) for default shell change"
    echo "  3. Your fish shell is configured with custom aliases and prompt"
    echo ""
    echo "To make future changes:"
    echo "  - Edit home.nix"
    echo "  - Run: home-manager switch --flake .#aragao"
    echo ""
else
    echo "❌ Failed to apply Home Manager configuration"
    echo "Check the error messages above and try again."
    exit 1
fi

# Live mode - monitor files and auto-apply changes
if [[ "$LIVE_MODE" == "true" ]]; then
    echo ""
    echo "🔄 Entering live mode - monitoring nix files for changes..."
    echo "Press Ctrl+C to exit live mode"
    echo ""
    
    # Monitor all .nix files and flake.lock for changes
    find . -name "*.nix" -o -name "flake.lock" | entr -r bash -c '
        echo "📄 Nix file changed - reapplying configuration..."
        echo "⏰ $(date)"
        if '"$HM_CMD"' switch --flake .#aragao -b backup 2>/dev/null; then
            echo "✅ Configuration applied successfully!"
        else
            echo "❌ Configuration failed - check your nix files"
        fi
        echo "👀 Watching for more changes..."
        echo ""
    '
fi