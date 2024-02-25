{ config, ... }:
let
  oh-my-zsh = "${config.xdg.configHome}/oh-my-zsh-custom/";
in
{
  home.file."${oh-my-zsh}" = {
    recursive = true;
    source = ./oh-my-zsh;
  };
}
