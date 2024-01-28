{ nixos-wsl, pkgs, ... }:
{
  fonts.packages = with pkgs; [
    noto-fonts
  ];

  environment.systemPackages = with pkgs; [
    emacs
    wget
  ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };
}
