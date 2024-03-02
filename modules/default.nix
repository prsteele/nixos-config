{ nixpkgs-unstable, ... }:
rec {
  base-config = import ./base-config.nix;
  base-home = import ./base-home.nix;
  base-nixos = import ./base-nixos.nix;
  base-overlays = {
    nixpkgs.overlays = builtins.attrValues (import ../overlays { inherit nixpkgs-unstable; });
  };
  base-all = {
    imports = [
      base-config
      base-home
      base-nixos
      base-overlays
    ];
  };
}
