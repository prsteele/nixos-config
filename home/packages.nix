{ pkgs, ... }:
{
  home.packages = with pkgs; [
    emacs
    coreutils-full
    unzip
    zip
  ];
}
