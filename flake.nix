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

      mkNixos = cfg: machine:
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

      configs = {
        wsl = {
          local-config = {
            user = "nixos";
            graphical = true;
            allowUnfree = true;
            system = "x86_64-linux";
          };
        };

        thinkpad = {
          local-config = {
            user = "prsteele";
            graphical = true;
            allowUnfree = true;
            system = "x86_64-linux";
          };
        };
      };

    in
    {
      nixosConfigurations = {
        wsl = mkNixos configs.wsl ./machines/wsl;
        thinkpad = mkNixos configs.thinkpad ./machines/thinkpad-e14;
      };

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);
    };
}
