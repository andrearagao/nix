{
  description = "Development environment with fish shell and golang";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils }:
    {
      # Home Manager configurations (not system-specific)
      homeConfigurations.aragao = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-linux;
        modules = [ ./home.nix ];
      };
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # Development shell (optional, for temporary development)
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            home-manager.packages.${system}.default
          ];

          shellHook = ''
            echo "Home Manager development environment"
            echo "To apply your home-manager configuration, run:"
            echo "  home-manager switch --flake .#aragao"
            echo ""
            echo "To build without switching:"
            echo "  home-manager build --flake .#aragao"
          '';
        };
      });
}
