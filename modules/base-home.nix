{ config, home-manager, lib, ... }:
{
  home-manager.extraSpecialArgs = { nixos-config = config; };
  home-manager.useGlobalPkgs = lib.mkDefault true;
}
