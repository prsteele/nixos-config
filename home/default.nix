extraSpecialArgs:
{ home-manager, ... }:
{
  imports = [
    home-manager.nixosModules.default
    ./home.nix
  ];

  home-manager.extraSpecialArgs = extraSpecialArgs;
}
