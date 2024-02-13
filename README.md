# NixOS configuration

A flake-based NixOS configuration.

## Flake structure

`nixosModules.base` represents an abstract machine template that is
specialized by different `nixosConfigurations` hosts. We use
`nixos-generators` to produce AWS-compatible machine images for the
`aws` "machine."

## Repository structure

* `machines/` contains machine-specific configuration. "Machine" also
  refers to VMs.
* `system/` contains NixOS configuration.
* `home/` contains per-user Home Manager configuration.
    * `home/packages/` contains different sets of packages; which are
      installed is controlled via configuration.
* `overlays/` defines overlays.
* `modules/` defines locally-defined modules.
