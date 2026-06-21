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
        nerd-fonts.fira-code
        nerd-fonts.droid-sans-mono
        nerd-fonts.noto
        fira-mono
        uiua386
      ];
    };
}
