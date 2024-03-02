{ nixpkgs-unstable }:
{
  emacs-unstable = import ./unstable-emacs.nix { inherit nixpkgs-unstable; };
  tmux-monokai = import ./tmux-monokai.nix;
}
