{ pkgs, local-config, ... }:
{
  fonts.packages = with pkgs; [
    noto-fonts
  ];

  environment.systemPackages = with pkgs; [
    emacs
    wget
  ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  nixpkgs.config.allowUnfree = local-config.allowUnfree;

  programs.zsh.enable = true;

  users.users.${local-config.user}.shell = pkgs.zsh;
}
