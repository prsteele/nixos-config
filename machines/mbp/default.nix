{ home-manager-darwin, nix-darwin, nixpkgs-darwin, ... }@inputs:
let
  user = "prsteele";
  system = "aarch64-darwin";
in
nix-darwin.lib.darwinSystem {
  inherit system;
  specialArgs = inputs;
  modules = [
    ({ pkgs, self, ... }: {
      imports = [
        # Defaults
        ../../modules

        # Home manager
        home-manager-darwin.darwinModules.home-manager
      ];

      # User
      users.users.${user} = {
        name = user;
        home = "/Users/${user}";
        shell = pkgs.zsh;
      };

      # HM
      home-manager.users.${user} = import ./home.nix;

      # Local config
      prs = {
        tmux-monokai-theme.enable = true;
        hm-base.enable = true;
        nixos-base.enable = true;
        fonts.enable = true;
      };
      nixpkgs.pkgs = nixpkgs-darwin.legacyPackages.${system}; # Use Darwin-specific packages
      services.nix-daemon.enable = true;

      system.stateVersion = 5;
    })
  ];
}
