# Nix Home Manager Configuration

This repository contains a Nix flake configuration for managing dotfiles and user environment with Home Manager.

## Features

- Fish shell as default shell with custom configuration
- Starship prompt with custom styling
- Comprehensive Git configuration
- Go development environment
- Modern CLI tools (eza, bat, fzf, ripgrep, fd)
- Direnv integration for project-specific environments

## Setup

1. **Install Nix** (if not already installed):
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```

2. **Enable flakes** (if not already enabled):
   ```bash
   mkdir -p ~/.config/nix
   echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
   ```

3. **Clone this repository**:
   ```bash
   git clone <your-repo-url>
   cd <repo-directory>
   ```

4. **Apply the Home Manager configuration**:
   ```bash
   nix run home-manager/master -- switch --flake .#aragao
   ```

## Usage

### Applying Changes
After modifying `home.nix`, apply the changes:
```bash
home-manager switch --flake .#aragao
```

### Building Without Switching
To test your configuration without applying it:
```bash
home-manager build --flake .#aragao
```

### Development Shell
Enter a temporary development environment:
```bash
nix develop
```

## Configuration Files

- `flake.nix` - Main flake configuration defining inputs and outputs
- `home.nix` - Home Manager configuration with all user settings
- `flake.lock` - Lock file ensuring reproducible builds

## Customization

### Fish Shell
The Fish shell is configured with:
- Custom aliases for common Git and Go commands
- Vi key bindings
- Custom functions (`mkcd`, `gitclean`)
- Environment variables (GOPATH, EDITOR)

### Git Configuration
Update your Git user information in `home.nix`:
```nix
programs.git = {
  userName = "your-name";
  userEmail = "your-email@example.com";
};
```

### Adding New Programs
Add new programs by extending the `home.nix` configuration. See the [Home Manager options](https://mipmip.github.io/home-manager-option-search/) for available programs.

## Fish as Default Shell

The configuration automatically sets Fish as your default shell. The setup includes:
- Shell integration for all tools (starship, direnv, fzf, eza)
- Custom prompt with Git integration
- Vi key bindings
- Autosuggestions and syntax highlighting

## Troubleshooting

- **Fish not starting**: Ensure the configuration is applied with `home-manager switch`
- **Command not found**: Check if the package is listed in `home.packages`
- **Git configuration**: Update the placeholder email in `home.nix`