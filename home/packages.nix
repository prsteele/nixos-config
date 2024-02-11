{ nixos-config, pkgs, ... }:
let
  nonfree = nixos-config.nixpkgs.config.allowUnfree;
  graphical = nixos-config.graphicalSystem;

  nonfree-graphical-packages =
    if nonfree && graphical
    then with pkgs; [
      discord
      spotify
      zoom
    ]
    else [ ];

  nonfree-nongraphical-packages =
    if nonfree
    then with pkgs; [ ]
    else [ ];

  graphical-packages =
    if graphical
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
    nonfree-graphical-packages
    nonfree-nongraphical-packages
  ];
}
