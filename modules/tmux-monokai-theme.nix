/* Add the tmux-monokai theme to known tmux plugins */
{ config, lib, ... }:
with lib;
{
  options = {
    prs.tmux-monokai-theme.enable = mkEnableOption "Add the Monokai theme to tmux plugins";
  };
  config =
    let
      cfg = config.prs.tmux-monokai-theme;
    in
    mkIf cfg.enable {
      nixpkgs.overlays = [
        (final: prev: {
          tmuxPlugins = prev.tmuxPlugins // {
            monokai = prev.callPackage ../pkgs/tmux-monokai-theme { };
          };
        })
      ];
    };
}
