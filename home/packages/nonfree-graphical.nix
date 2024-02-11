{ lib, nixos-config, pkgs, ... }:
let
  nonfree = nixos-config.nixpkgs.config.allowUnfree;
  graphical = nixos-config.graphicalSystem;
in
{
  home.packages = lib.mkIf (nonfree && graphical)
    (with pkgs;
    [
      discord
      spotify
      zoom
    ]);
}
