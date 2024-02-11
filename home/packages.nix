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
      pavucontrol
      pwvucontrol
      yakuake
      protonvpn-gui
    ]
    else [ ];

  non-graphical-packages = with pkgs; [
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
in
{
  home.packages = builtins.concatLists [
    non-graphical-packages
    graphical-packages
    nonfree-packages
  ];
}
