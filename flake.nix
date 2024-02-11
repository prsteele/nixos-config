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

      mkNixos = machine: cfg:
        let
          # Propagate local-config (the only attribute of cfg) to
          # NixOS and HM modules
          specialArgs = inputs // cfg;
        in
        nixpkgs.lib.nixosSystem {
          system = cfg.local-config.system;
          specialArgs = specialArgs;
          modules = [
            machine
            ./overlays
            ./system
            home-manager.nixosModules.default
            (args: {
              home-manager.useGlobalPkgs = true;
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.users.${specialArgs.local-config.user} = import ./home args;
            })
          ];
        };
    in
    {
      nixosConfigurations = {
        wsl = mkNixos ./machines/wsl {
          local-config = {
            user = "nixos";
            graphical = true;
            allowUnfree = true;
            system = "x86_64-linux";
          };
        };
        thinkpad = mkNixos ./machines/thinkpad-e14 {
          local-config = {
            user = "prsteele";
            graphical = true;
            allowUnfree = true;
            system = "x86_64-linux";
          };
        };
        aws-x86_64 = mkNixos ./machines/aws {
          local-config = {
            user = "prsteele";
            graphical = false;
            allowUnfree = true;
            system = "x86_64-linux";
          };
        };
        aws-aarch64 = mkNixos ./machines/aws {
          local-config = {
            user = "prsteele";
            graphical = false;
            allowUnfree = true;
            system = "aarch64-linux";
          };
        };
      };


      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);
    };
}
