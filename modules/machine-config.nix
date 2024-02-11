{ lib, ... }:
{
  options = {
    defaultUser = lib.mkOption {
      type = lib.types.str;
      description = "The default machine username";
    };

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
