{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    fira-mono
    (nerdfonts.override { fonts = [ "FiraCode" "Noto" ]; })
  ];
}
