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
    in
    {
      # WSL
      nixosConfigurations.nixos =
        let
          user = "nixos";
        in
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = inputs // { inherit user; };
          modules = [
            ./machines/wsl.nix
            ./system
            home-manager.nixosModules.default
            (args: {
              home-manager.useGlobalPkgs = true;
              home-manager.users.${user} = import ./home args;
            })
          ];
        };

      homeConfigurations.nixos = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        extraSpecialArgs = { user = "nixos"; };
        modules = [ ./home ];
      };

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);
    };
}
