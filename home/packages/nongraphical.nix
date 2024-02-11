{ pkgs, ... }:
{
  home.packages = with pkgs; [
    coreutils-full
    emacs
    htop
    ispell
    jq
    nil
    nixpkgs-fmt
    protonvpn-cli
    tree
    unzip
    zip
    curl
  ];
}
