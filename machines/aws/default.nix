{ modulesPath, ... }:
{
  defaultUser = "prsteele";
  graphicalSystem = false;
  desktopSystem = false;
  nixpkgs.config.allowUnfree = true;

  imports = [
    (modulesPath + "/virtualisation/amazon-image.nix")
  ];

  # We need more temp space to build
  formatConfigs.amazon = { ... }: {
    amazonImage.sizeMB = 16 * 1024;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
