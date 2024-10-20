/* Typical NixOS configuration */
{ config, lib, pkgs, ... }:
with lib;
{
  options = {
    prs.nixos-base.enable = mkEnableOption "NixOS base configuration";
  };

  config =
    let
      cfg = config.prs.nixos-base;
    in
    mkIf cfg.enable {
      nix = mkDefault {
        package = pkgs.nixFlakes;
        extraOptions = "experimental-features = nix-command flakes";
      };

      programs.zsh.enable = mkDefault true;
      time.timeZone = mkDefault "America/New_York";
      nixpkgs.config.allowUnfree = mkDefault true;
      documentation.enable = mkDefault true;
      documentation.man.enable = mkDefault true;
      documentation.dev.enable = mkDefault true;
    };
}

