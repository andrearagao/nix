# Nix Home Manager Configuration

This repository contains a comprehensive Nix flake configuration for managing dotfiles and user environment with Home Manager, specifically designed for a development workstation with extensive tooling.

## Features

### Core Development Environment
- **Fish shell** as default shell with extensive custom configuration
- **Go development environment** with full toolchain (gopls, delve, golangci-lint)
- **Neovim** with Lazy.nvim plugin manager and comprehensive development setup
- **Starship prompt** with custom styling and Git integration
- **Zoxide** for intelligent directory navigation

### Development Tools
- **Git** with conditional configuration for work/personal projects
- **GPG** with SSH agent integration and multiple key support
- **Direnv** with nix-direnv for project-specific environments
- **Tmux** with Rose Pine theme and enhanced keybindings
- **Yazi** file manager with custom keybindings and preview support

### CLI Tools & Utilities
- **Modern file tools**: eza, bat, ripgrep, fd, tree
- **Search & navigation**: fzf, zoxide
- **System monitoring**: htop, gdu, fastfetch
- **Development utilities**: entr, lolcat, fortune

### Cloud & Infrastructure
- **Kubernetes**: kubectl, helm, k9s, kubectx, kustomize, tilt
- **Containerization**: Docker, Docker Compose
- **Infrastructure as Code**: Terraform
- **Cloud platforms**: AWS CLI, Azure CLI, Google Cloud SDK
- **Service mesh**: Istio

### Language Support
- **Go**: Complete development toolchain
- **Node.js**: TypeScript and Bash language servers
- **Markdown**: Marksman language server
- **Nix**: nil language server and alejandra formatter

### AI & Productivity
- **Ollama** for local AI models
- **Obsidian** for note-taking
- **Auto-sync systemd service** for notes repository

### Wayland & Desktop Integration
- Full Wayland support for modern Linux desktop
- Electron and Qt application compatibility
- Firefox and Mozilla applications optimized for Wayland

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
- `neovim/` - Comprehensive Neovim configuration with Lazy.nvim
- `flake.lock` - Lock file ensuring reproducible builds

## Key Configurations

### Fish Shell
The Fish shell is configured with:
- Extensive aliases for Git, Go, Kubernetes, Docker, and Terraform
- Custom functions for development workflows (`mkcd`, `gitclean`, `kpf`, `kshell`, `kwait`)
- Vi key bindings and custom key mappings
- Environment variables for Go development and Wayland support
- Custom greeting with fastfetch and fortune

### Git Configuration
Multi-account Git setup with conditional includes:
- **Work projects** (`/home/aragao/projects/work/`): Uses work email and GPG key
- **Personal projects** (`/home/aragao/projects/personal/`): Uses personal email and GPG key
- Automatic GPG signing for commits and tags
- Custom aliases for common Git operations

### Neovim Setup
Modern Neovim configuration featuring:
- **Lazy.nvim** plugin manager
- **LSP support** for Go, TypeScript, and other languages
- **Telescope** for fuzzy finding and navigation
- **Treesitter** for syntax highlighting and code analysis
- **Lualine** status bar with custom styling
- **Trouble** for diagnostics and quickfix
- **DAP** for debugging support
- **Conform** for code formatting
- **Oil** for file tree navigation

### Tmux Configuration
Enhanced terminal multiplexer with:
- Rose Pine theme styling
- Vi key bindings
- Mouse support and better scrolling
- Window management improvements
- Plugin integration (sensible, vim-tmux-navigator, tmux-fzf)

### Kubernetes & Cloud Tools
Comprehensive cloud development setup:
- **kubectl** with custom aliases and functions
- **k9s** for cluster management
- **kubectx/kubens** for context switching
- **Helm** for package management
- **Terraform** for infrastructure
- **Docker** with custom aliases

## Customization

### Adding New Programs
Add new programs by extending the `home.packages` list in `home.nix`:
```nix
home.packages = with pkgs; [
  your-new-package
  another-package
];
```

### Modifying Shell Aliases
Update shell aliases in the `programs.fish.shellAliases` section:
```nix
shellAliases = {
  custom = "your-command";
};
```

### Neovim Configuration
Add new Neovim plugins or modify existing configuration in the `neovim/` directory. The configuration is modular and easy to extend.

## System Integration

### Wayland Support
The configuration includes comprehensive Wayland support for modern Linux desktops, ensuring compatibility with:
- Electron applications
- Qt applications
- Firefox and other Mozilla applications
- SDL applications
- Java applications

### Auto-sync Service
A systemd user service automatically syncs the notes repository every 15 minutes, with desktop notifications for successful syncs.

## Troubleshooting

- **Fish not starting**: Ensure the configuration is applied with `home-manager switch`
- **Command not found**: Check if the package is listed in `home.packages`
- **Git configuration**: Update the email addresses in `home.nix` for your work and personal accounts
- **GPG issues**: Verify your GPG keys are properly configured and the agent is running
- **Wayland issues**: Check that the Wayland environment variables are properly set

## Dependencies

This configuration requires:
- Nix with flakes enabled
- Home Manager
- A Linux system (tested on Arch Linux with aarch64)
- GPG keys for Git signing (optional but recommended)

## Contributing

Feel free to submit issues or pull requests to improve this configuration. The setup is designed to be modular and easily extensible.