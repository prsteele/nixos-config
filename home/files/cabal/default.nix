{ config, ... }:
let
  cabal = "${config.xdg.configHome}/cabal/config";
in
{
  home.file.${cabal} = {
    text = import ./config.nix config.xdg.configHome;
  };
}
