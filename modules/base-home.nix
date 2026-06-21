/* Typical Home Manager configuration */
{ config, lib, ... }:
with lib;
{
  options = {
    prs.hm-base.enable = mkEnableOption "Home Manager base configuration";
  };

  config =
    let
      cfg = config.prs.hm-base;
    in
    mkIf cfg.enable {
      home-manager.extraSpecialArgs = { nixos-config = config; };
      home-manager.useGlobalPkgs = lib.mkDefault true;
    };
}
