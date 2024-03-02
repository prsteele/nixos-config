{ lib, nixos-config, pkgs, ... }:
let
  graphical = nixos-config.graphicalSystem;
in
{
  home.packages = lib.mkIf graphical (
    with pkgs; [
      firefox
      inkscape
      kitty
      ksshaskpass
      nixpkgs-fmt
      pavucontrol
      protonvpn-gui
      pwvucontrol
      yakuake
    ]
  );
}
