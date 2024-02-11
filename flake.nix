{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    nixos-wsl.url = "github:nix-community/nixos-wsl";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
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
            ./system
            home-manager.nixosModules.default
            (args: {
              home-manager.useGlobalPkgs = true;
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.users.${specialArgs.local-config.user} = import ./home args;
            })
          ];
        };

      mkHome = cfg:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${cfg.local-config.system};
          extraSpecialArgs = (inputs // cfg);
          modules = [ ./home ];
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
      # WSL
      nixosConfigurations.nixos = mkNixos configs.wsl ./machines/wsl;

      # Thinkpad
      nixosConfigurations.thinkpad = mkNixos configs.thinkpad ./machines/thinkpad-e14;

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);
    };
}
