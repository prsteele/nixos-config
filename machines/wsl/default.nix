{ nixpkgs, ... }@inputs:
let
  user = "nixos";
in
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = inputs;
  modules = [
    ({ home-manager, nixos-wsl, pkgs, ... }: {
      imports = [
        # WSL
        nixos-wsl.nixosModules.wsl

        # Local modules
        ../../modules

        # Home manager
        home-manager.nixosModules.default
      ];

      # User
      users.users.${user} = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        shell = pkgs.zsh;
      };

      # WSL
      wsl.enable = true;
      wsl.defaultUser = user;

      # HM
      home-manager.users.${user} = import ./home.nix;

      # Local config
      prs = {
        tmux-monokai-theme.enable = true;
        hm-base.enable = true;
        nixos-base.enable = true;
        fonts.enable = true;
      };
      programs.ssh.startAgent = true;
      hardware.opengl.enable = true;

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It's perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "23.11"; # Did you read the comment?
    })
  ];
}
