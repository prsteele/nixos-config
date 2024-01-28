{ nixos-wsl, user, ... }:
{
  imports = [
    nixos-wsl.nixosModules.wsl
  ];

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  wsl.enable = true;
  wsl.defaultUser = user;
}
