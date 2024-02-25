{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
    , home-manager
    , nixos-generators
    , nixos-wsl
    , ...
    }:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    in
    {
      overlays = {
        unstable-emacs = import ./overlays/unstable-emacs.nix { inherit nixpkgs-unstable; };
        tmux-monokai = import ./overlays/tmux-monokai.nix;
      };

      nixosModules =
        let
          modules = ./modules;
          system = import ./system { inherit nixos-generators; };
          home = import ./home { inherit home-manager; };
        in
        {
          base = {
            imports = [
              modules
              system
              home
              {
                nixpkgs.overlays = [
                  self.overlays.unstable-emacs
                  self.overlays.tmux-monokai
                ];
              }
            ];
          };
        };

      nixosConfigurations = {
        wsl = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            (import ./machines/wsl { inherit nixos-wsl; })
            self.nixosModules.base
          ];
        };
        thinkpad = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./machines/thinkpad-e14
            self.nixosModules.base
          ];
        };
        aws = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./machines/aws
            self.nixosModules.base
          ];
        };
      };

      packages = forAllSystems (system:
        {
          aws-ami = self.nixosConfigurations.aws.config.formats.amazon;
        }
      );

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);
    };
}
