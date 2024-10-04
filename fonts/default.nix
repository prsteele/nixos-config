{ pkgs, ... }:
let
  uiua386 = pkgs.uiua386.overrideAttrs (prev: {
    src = pkgs.fetchFromGitHub {
      owner = "uiua-lang";
      repo = "uiua";
      rev = "d06d613698f355439c20538ff6e6d4e8b06e5205";
      hash = "sha256-lqFDzM6EscC8cFPGq/JnEybctaurNRoEQi0zxFaKgwI=";
    };
  });
in
{
  fonts.packages = with pkgs; [
    fira-mono
    uiua386
    (nerdfonts.override { fonts = [ "FiraCode" "Noto" ]; })
  ];
}
