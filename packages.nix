{ pkgs, ... }:
{
  home.packages = with pkgs; [
    emacs
    coreutils-full
    home-manager
    unzip
    zip
  ];
}
