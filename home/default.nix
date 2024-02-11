extraSpecialArgs:
{ config, home-manager, ... }:
{

  imports = [
    home-manager.nixosModules.default
    ./home.nix
  ];


  home-manager.extraSpecialArgs = extraSpecialArgs // { nixos-config = config; };
}
