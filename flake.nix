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

  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
    , home-manager
    , nixos-generators
    , nixos-wsl
    , ...
    }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    in
    {
      nixosModules =
        let
          # Since we define machine configuration as modules, we need to
          # plumb flake inputs manually
          modules = ./modules;
          overlays = import ./overlays { inherit nixpkgs-unstable; };
          system = ./system;
          home = import ./home { inherit home-manager; };
        in
        {
          wsl = {
            imports = [
              (import ./machines/wsl { inherit nixos-wsl; })
              modules
              overlays
              system
              home
            ];
          };

          thinkpad = {
            imports = [
              ./machines/thinkpad-e14
              modules
              overlays
              system
              home
            ];
          };

          aws = {
            imports = [
              (import ./machines/aws { inherit nixos-generators; })
              modules
              overlays
              system
              home
            ];
          };
        };

      nixosConfigurations = {
        wsl = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ self.nixosModules.wsl ];
        };
        thinkpad = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ self.nixosModules.thinkpad ];
        };
        aws = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ self.nixosModules.aws ];
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
