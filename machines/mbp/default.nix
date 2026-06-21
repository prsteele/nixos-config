{ home-manager-darwin, nix-darwin, nixpkgs-darwin, ... }@inputs:
let
  user = "prsteele";
  system = "aarch64-darwin";
in
nix-darwin.lib.darwinSystem {
  inherit system;
  specialArgs = inputs;
  modules = [
    ({ pkgs, self, config, ... }: {
      imports = [
        # Home manager
        home-manager-darwin.darwinModules.home-manager

        ../../modules/tmux-monokai-theme.nix
      ];

      nix = {
        extraOptions = "experimental-features = nix-command flakes";
      };

      # Use Darwin-specific packages
      nixpkgs = {
        pkgs = import nixpkgs-darwin { inherit system; };
        overlays = [
          self.overlays.emacs-packages
          self.overlays.my-emacs
        ];
      };

      # User
      users.users.${user} = {
        name = user;
        home = "/Users/${user}";
        shell = pkgs.zsh;
      };

      # HM
      home-manager = {
        extraSpecialArgs = { nixos-config = config; };
        useGlobalPkgs = true;

        users.${user} = import ./home.nix;
      };

      # Local config
      prs = {
        tmux-monokai-theme.enable = true;
      };

      # Fonts
      fonts.packages = with pkgs; [
        nerd-fonts.fira-code
        nerd-fonts.droid-sans-mono
        nerd-fonts.noto
        nerd-fonts.victor-mono
        fira-mono
        uiua386
        victor-mono
      ];

      # System packages
      #
      # Derivations exposing Mac applications should go here to show up in "Apps"
      environment.systemPackages = [
        pkgs.my-emacs
      ];

      # Mac cruft
      ids.gids.nixbld = 30000;

      system.stateVersion = 5;
    })
  ];
}
