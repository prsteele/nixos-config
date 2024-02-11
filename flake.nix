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
          system = import ./system { inherit nixos-generators; };
          home = import ./home { inherit home-manager; };
        in
        {
          base = {
            imports = [
              modules
              overlays
              system
              home
            ];
          };

          wsl = {
            imports = [
              (import ./machines/wsl { inherit nixos-wsl; })
              self.nixosModules.base
            ];
          };

          thinkpad = {
            imports = [
              ./machines/thinkpad-e14
              self.nixosModules.base
            ];
          };

          aws = {
            imports = [
              ./machines/aws
              self.nixosModules.base
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
