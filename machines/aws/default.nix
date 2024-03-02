{ nixpkgs, ... }@inputs:
let
  user = "prsteele";
  local = { home-manager, modulesPath, nixos-generators, pkgs, self, ... }: {
    imports = [
      (modulesPath + "/virtualisation/amazon-image.nix")

      nixos-generators.nixosModules.all-formats

      # Defaults
      self.nixosModules.base-all

      # Home manager
      home-manager.nixosModules.default
    ];

    graphicalSystem = false;
    desktopSystem = false;
    nixpkgs.config.allowUnfree = true;

    # We need more temp space to build
    formatConfigs.amazon = { ... }: {
      amazonImage.sizeMB = 16 * 1024;
    };

    users.users.${user} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
      ];
      shell = pkgs.zsh;
    };
    home-manager.users.${user} = import ../../home;

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
