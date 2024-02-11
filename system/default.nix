{ pkgs, config, ... }:
{
  fonts.packages = with pkgs; [
    noto-fonts
  ];

  environment.systemPackages = with pkgs; [
    emacs
    wget
  ];

  networking.enableIPv6 = true;
  networking.defaultGateway6 = {
    address = "fe80::1";
    interface = "eth0";
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  programs.zsh.enable = true;

  users.users.${config.defaultUser}.shell = pkgs.zsh;
}
