# Nixos options that should be applicable to any host
{ lib, pkgs, ... }:
{
  nix = lib.mkDefault {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  programs.zsh.enable = lib.mkDefault true;
  time.timeZone = lib.mkDefault "America/New_York";
}
