{ local-config, pkgs, ... }:
let
  graphical-packages =
    if local-config.graphical
    then with pkgs; [
      firefox
    ]
    else [ ];

  non-graphical-packages = with pkgs; [
    emacs
    coreutils-full
    unzip
    zip
  ];
in
{
  home.packages = non-graphical-packages ++ graphical-packages;
}
