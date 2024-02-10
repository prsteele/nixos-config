{ nixpkgs-unstable, ... }:
{
  nixpkgs.overlays = [
    (import ./unstable-emacs.nix { inherit nixpkgs-unstable; })
  ];
}
