{
  description = "NixOS and nix-darwin configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-23.11-darwin";
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
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    in
    {
      overlays = import ./overlays { inherit nixpkgs-unstable; };
      nixosModules = import ./modules { inherit nixpkgs-unstable; };

      nixosConfigurations = {
        wsl = import ./machines/wsl inputs;
        thinkpad = import ./machines/thinkpad-e14 inputs;
        aws = import ./machines/aws inputs;
      };

      darwinConfigurations = {
        mbp = import ./machines/mbp inputs;
      };

      packages = forAllSystems (system: {
        aws-ami = self.nixosConfigurations.aws.config.formats.amazon;
      });

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);
    };
}
