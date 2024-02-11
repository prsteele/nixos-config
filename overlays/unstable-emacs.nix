{ nixpkgs-unstable }:
final: prev: {
  emacs = nixpkgs-unstable.legacyPackages.${prev.system}.emacs;
}
