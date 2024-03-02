{ config, ... }:
let
  kitty = "${config.xdg.configHome}/kitty/kitty.conf";
in
{
  home.file.${kitty} = {
    source = ./kitty.conf;
  };
}
