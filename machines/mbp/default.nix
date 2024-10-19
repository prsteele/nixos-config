{ home-manager-darwin, nix-darwin, nixpkgs-darwin, ... }@inputs:
let
  user = "prsteele";
  system = "aarch64-darwin";
  local = { pkgs, self, ... }: {
    imports = [

      # Defaults
      self.nixosModules.base-config
      self.nixosModules.base-home
      self.nixosModules.base-nixos

      # Home manager
      home-manager-darwin.darwinModules.home-manager

      # Fonts
      ../../fonts
    ];

    graphicalSystem = false;
    desktopSystem = true;
    nixpkgs.config.allowUnfree = true;

    # Use Darwin-specific packages
    nixpkgs.pkgs = nixpkgs-darwin.legacyPackages.${system};

    nixpkgs.overlays = [ self.overlays.tmux-monokai ];

    services.nix-daemon.enable = true;

    users.users.${user} = {
      name = user;
      home = "/Users/${user}";
      shell = pkgs.zsh;
    };
    home-manager.users.${user} = import ./home.nix;

    system.stateVersion = 5;
  };
in
nix-darwin.lib.darwinSystem {
  inherit system;
  specialArgs = inputs;
  modules = [
    local
  ];
}
