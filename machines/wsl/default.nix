{ nixpkgs, ... }@inputs:
let
  user = "nixos";
  local = { config, home-manager, lib, nixos-wsl, self, pkgs, nixpkgs, ... }: {
    imports = [
      # WSL
      nixos-wsl.nixosModules.wsl

      # Defaults
      self.nixosModules.base-home
      self.nixosModules.base-nixos
      self.nixosModules.base-overlays

      # Home manager
      home-manager.nixosModules.default

      # Fonts
      ../../fonts
    ];

    nixpkgs.config.allowUnfree = true;
    wsl.enable = true;
    wsl.defaultUser = user;

    users.users.${user} = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      shell = pkgs.zsh;
    };
    home-manager.users.${user} = import ./home.nix;

    programs.ssh.startAgent = true;

    documentation.enable = true;
    documentation.man.enable = true;
    documentation.dev.enable = true;
    hardware.opengl.enable = true;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It's perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.11"; # Did you read the comment?
  };
in
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = inputs;
  modules = [ local ];
}
