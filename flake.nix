{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    nixos-wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;

      mkNixos = system: machine:
        nixpkgs.lib.nixosSystem {
          system = system;
          specialArgs = inputs;
          modules = [
            ./modules
            ./overlays
            machine
            ./system
            (import ./home inputs)
          ];
        };
    in
    {
      nixosConfigurations = {
        wsl = mkNixos "x86_64-linux" ./machines/wsl;
        thinkpad = mkNixos "x86_64-linux" ./machines/thinkpad-e14;
        aws-x86_64 = mkNixos "x86_64-linux" ./machines/aws;
        aws-aarch64 = mkNixos "aarch64-linux" ./machines/aws;
      };


      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);
    };
}
