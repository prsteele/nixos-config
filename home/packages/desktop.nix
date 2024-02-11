{ lib, nixos-config, pkgs, ... }:
{
  home.packages = lib.mkIf nixos-config.desktopSystem (
    with pkgs; [
      protonvpn-cli
    ]
  );
}
