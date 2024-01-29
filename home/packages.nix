{ local-config, pkgs, ... }:
let
  nonfree-packages =
    if local-config.allowUnfree
    then with pkgs; [
      discord
      spotify
      zoom
    ]
    else [ ];

  graphical-packages =
    if local-config.graphical
    then with pkgs; [
      firefox
      inkscape
      ksshaskpass
      nixpkgs-fmt
      yakuake
      protonvpn-gui
    ]
    else [ ];

  non-graphical-packages = with pkgs; [
    emacs
    coreutils-full
    htop
    ispell
    jq
    nil
    nixpkgs-fmt
    protonvpn-cli
    unzip
    zip
  ];
in
{
  home.packages = builtins.concatLists [
    non-graphical-packages
    graphical-packages
    nonfree-packages
  ];
}
