{ lib, ... }:
{
  options = {
    graphicalSystem = lib.mkOption {
      type = lib.types.bool;
      description = "Whether graphical packages should be installed";
    };

    desktopSystem = lib.mkOption {
      type = lib.types.bool;
      description = "Whether heavy-weight desktop utilities should be installed";
    };
  };
}
