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
echo "ℹ️  Using direct flake activation (no separate Home Manager installation needed)"

# Function to apply home manager configuration
apply_config() {
    echo "📝 Applying configuration..."
    if nix --extra-experimental-features "nix-command flakes" run .#homeConfigurations.aragao.activationPackage; then
        echo "✅ Home Manager configuration applied successfully!"
        return 0
    else
        echo "❌ Failed to apply Home Manager configuration"
        return 1
    fi
}

# Update flake inputs to latest versions (using experimental features)
echo "🔄 Updating flake inputs to latest versions..."
if nix --extra-experimental-features "nix-command flakes" flake update; then
    echo "✅ Flake inputs updated"
else
    echo "⚠️  Failed to update flake inputs, continuing with existing versions..."
fi

# Validate flake configuration (using experimental features)
echo "🔍 Validating flake configuration..."
if ! nix --extra-experimental-features "nix-command flakes" flake check 2>/dev/null; then
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
    
    echo ""
    echo "🎉 Setup complete!"
    echo ""
    echo "Next steps:"
    echo "  1. Update your Git email in home.nix if needed"
    echo "  2. Restart your terminal to apply all changes"
    echo "  3. Your fish shell is available with custom aliases and prompt"
    echo ""
    echo "To make future changes:"
    echo "  - Edit home.nix"
    echo "  - Run: nix run .#homeConfigurations.aragao.activationPackage"
    echo "  - Or use the traditional: home-manager switch --flake .#aragao"
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
    
    # Create a temporary script for the live mode command
    LIVE_SCRIPT=$(mktemp)
    cat > "$LIVE_SCRIPT" << 'EOF'
#!/bin/bash
# Debounce function to prevent multiple rapid executions
if [[ -f /tmp/nix-live-mode.lock ]]; then
    echo "⏳ Update already in progress, skipping..."
    exit 0
fi

# Create lock file
touch /tmp/nix-live-mode.lock

echo "📄 Nix file changed - reapplying configuration..."
echo "⏰ $(date)"

# Apply configuration
if nix --extra-experimental-features "nix-command flakes" run .#homeConfigurations.aragao.activationPackage 2>/dev/null; then
    echo "✅ Configuration applied successfully!"
else
    echo "❌ Configuration failed - check your nix files"
fi

# Remove lock file after a short delay to allow for file operations to complete
sleep 1
rm -f /tmp/nix-live-mode.lock

echo "👀 Watching for more changes..."
echo ""
EOF

    chmod +x "$LIVE_SCRIPT"
    
    # Monitor all .nix files and flake.lock for changes
    # Alternative: Use inotifywait for more reliable file monitoring (if available)
    if command -v inotifywait &> /dev/null; then
        echo "🔍 Using inotifywait for file monitoring (more reliable)"
        echo "👀 Waiting for file changes... (no initial update)"
        while true; do
            # Wait for file changes, then execute the update script
            inotifywait -q -e modify,create,delete -r . --include=".*\.nix$" --include="flake\.lock" 2>/dev/null
            if [[ $? -eq 0 ]]; then
                "$LIVE_SCRIPT"
            fi
        done
    else
        echo "🔍 Using entr for file monitoring"
        echo "👀 Waiting for file changes... (no initial update)"
        # Use entr without -r flag to avoid automatic restarts
        find . -name "*.nix" -o -name "flake.lock" | entr "$LIVE_SCRIPT"
    fi
    
    # Clean up temporary script on exit
    trap "rm -f '$LIVE_SCRIPT' /tmp/nix-live-mode.lock; echo '🧹 Cleaned up live mode files'; exit" INT TERM EXIT
fi