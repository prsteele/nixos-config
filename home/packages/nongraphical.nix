{ pkgs, ... }:
{
  home.packages = with pkgs; [
    awscli2
    coreutils-full
    emacs
    htop
    ispell
    jq
    nil
    nixpkgs-fmt
    tree
    unzip
    zip
    curl
  ];
}
