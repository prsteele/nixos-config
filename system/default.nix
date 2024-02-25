{ nixos-generators }:
{ lib, pkgs, config, ... }:
{
  imports = [
    nixos-generators.nixosModules.all-formats
  ];
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "Noto" ]; })
  ];

  environment.systemPackages = with pkgs; [
    emacs
    wget
  ];

  networking.enableIPv6 = true;
  networking.defaultGateway6 = {
    address = "fe80::1";
    interface = "eth0";
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  programs.zsh.enable = true;

  users.users.${config.defaultUser} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

  time.timeZone = "America/New_York";
}
