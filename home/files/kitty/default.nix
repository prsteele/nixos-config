{ config, ... }:
{
  home.file."${config.xdg.configHome}/kitty/kitty.conf" = {
    source = ./kitty.conf;
  };
}
