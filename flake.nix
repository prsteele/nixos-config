{
  description = "NixOS and nix-darwin configurations";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs";

    # Mac support
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";
    home-manager-darwin = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    # WSL support
    nixos-wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # HM
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS generators
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Known systems
    systems = {
      url = "github:nix-systems/default";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-darwin, nixpkgs-unstable, nix-darwin, systems, ... }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs (import systems);

      isDarwin = system: [ ] == builtins.match ".*-darwin" system;

      mkPkgs = system:
        if isDarwin system
        then nixpkgs-darwin.legacyPackages.${system}
        else nixpkgs.legacyPackages.${system};

    in
    {
      nixosConfigurations = {
        wsl = import ./machines/wsl inputs;
        thinkpad = import ./machines/thinkpad-e14 inputs;
        aws = import ./machines/aws inputs;
      };

      darwinConfigurations = {
        mbp = import ./machines/mbp inputs;
      };

      packages = forAllSystems
        (system:
          let
            pkgs = mkPkgs system;
          in
          {
            rebuild = pkgs.writeShellApplication
              {
                name = "local-rebuild";
                runtimeInputs =
                  if isDarwin system
                  then [ nix-darwin.packages.${system}.default ]
                  else [ ];
                text =
                  if isDarwin system
                  then ''darwin-rebuild switch --flake "$@"''
                  else ''nixos-rebuild switch --flake "$@"'';
              };

            aws-ami = self.nixosConfigurations.aws.config.formats.amazon;
          });

      formatter = forAllSystems (system:
        let
          pkgs = mkPkgs system;
        in
        pkgs.nixpkgs-fmt
      );
    };
}
