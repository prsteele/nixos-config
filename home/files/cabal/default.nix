{ config, ... }:
let
  cabal = "${config.xdg.configHome}/cabal/config";
in
{
  home.file.${cabal} = {
    source = ./config;
  };
}
