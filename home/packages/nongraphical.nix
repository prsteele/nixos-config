{ pkgs, ... }:
{
  home.packages = with pkgs; [
    awscli2
    coreutils-full
    curl
    emacs
    htop
    ispell
    jq
    nil
    nixpkgs-fmt
    (python3.withPackages (ps: [ ps.pip ]))
    tree
    unzip
    zip
  ];
}
