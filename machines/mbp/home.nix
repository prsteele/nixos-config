{ pkgs, ... }:
{
  imports = [
    ../../home
  ];

  home.packages = with pkgs;
    let
      my-python-lsp-server = python3.pkgs.toPythonApplication python3.pkgs.python-lsp-server;
      my-python = python3.withPackages (ps: [ ps.pip ]);
    in
    [
      awscli2
      coreutils-full
      curl
      htop
      ispell
      jq
      my-python
      my-python-lsp-server
      nil
      nixpkgs-fmt
      ruff
      tree
      unzip
      zip
    ];

  home.sessionVariables = {
    EDITOR = "emacs";
    VISUAL = "emacs";
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.
}
