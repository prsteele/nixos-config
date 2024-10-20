{ pkgs }:
pkgs.tmuxPlugins.mkTmuxPlugin {

  pluginName = "monokai";
  version = "0.1";
  src = ./.;
}
