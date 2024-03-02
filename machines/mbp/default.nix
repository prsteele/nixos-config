{ home-manager, nix-darwin, nixpkgs-darwin, ... }@inputs:
let
  user = "prsteele";
  system = "aarch64-darwin";
  local = { pkgs, self, ... }: {
    imports = [

      # Defaults
      self.nixosModules.base-all

      # Home manager
      home-manager.darwinModules.home-manager

      # Fonts
      ../../fonts/darwin.nix
    ];

    graphicalSystem = false;
    desktopSystem = true;
    nixpkgs.config.allowUnfree = true;

    # Use Darwin-specific packages
    nixpkgs.pkgs = nixpkgs-darwin.legacyPackages.${system};

    services.nix-daemon.enable = true;

    users.users.${user} = {
      name = user;
      home = "/Users/${user}";
      shell = pkgs.zsh;
    };
    home-manager.users.${user} = import ../../home;
  };
in
nix-darwin.lib.darwinSystem {
  inherit system;
  specialArgs = inputs;
  modules = [
    local
  ];
}
