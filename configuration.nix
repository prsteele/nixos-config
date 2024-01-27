{ config, lib, pkgs, home-manager, nixos-wsl, ... }:

{
  imports = [
    # include NixOS-WSL modules
    nixos-wsl.nixosModules.wsl

    # home-manager
    home-manager.nixosModules.default
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  fonts.packages = with pkgs; [
    noto-fonts
  ];

  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
  home-manager.users.nixos = ./home.nix;

  environment.systemPackages = with pkgs; [
    emacs
    wget
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
