{ home-manager }:
{ config, ... }:
{

  imports = [
    home-manager.nixosModules.default
    ./home.nix
  ];

  home-manager.extraSpecialArgs = { nixos-config = config; };

}
