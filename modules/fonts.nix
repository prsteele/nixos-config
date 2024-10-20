/* Fonts to install */
{ config, lib, pkgs, ... }:
with lib;
{
  options = {
    prs.fonts.enable = mkEnableOption "Install the Uiua386 font";
  };

  config =
    let
      cfg = config.prs.fonts;
    in
    mkIf cfg.enable {
      fonts.packages = with pkgs; [
        (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "Hasklig" "Noto" ]; })
        fira-mono
        (pkgs.callPackage ../pkgs/uiua386.nix { })
      ];
    };
}

