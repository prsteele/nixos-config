{ pkgs, ... }:
{
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    fira-mono
    (nerdfonts.override { fonts = [ "FiraCode" "Noto" ]; })
  ];
}
