{ lib, nixos-config, pkgs, ... }:
let
  graphical = nixos-config.graphicalSystem;
in
{
  home.packages = lib.mkIf graphical (
    with pkgs; [
      firefox
      inkscape
      ksshaskpass
      nixpkgs-fmt
      pavucontrol
      pwvucontrol
      yakuake
      protonvpn-gui
    ]
  );
}
