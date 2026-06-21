{ pkgs, ... }:
{
  home.packages = with pkgs; [
    awscli2
    coreutils-full
    curl
    htop
    ispell
    jq
    nil
    nixpkgs-fmt
    (python3.withPackages (ps: [ ps.pip ]))
    (python3.pkgs.toPythonApplication python3.pkgs.python-lsp-server)
    ruff
    tree
    unzip
    zip
  ];
}
