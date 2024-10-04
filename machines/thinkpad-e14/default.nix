{ nixpkgs, ... }@inputs:
let
  user = "prsteele";
  local = { home-manager, lib, pkgs, self, ... }: {
    nixpkgs.config.allowUnfree = true;
    graphicalSystem = true;
    desktopSystem = true;

    imports = [
      ./hardware-configuration.nix

      # Defaults
      self.nixosModules.base-all

      # Home manager
      home-manager.nixosModules.default

      # Fonts
      ../../fonts
    ];

    users.users.${user} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkManager"
      ];
      shell = pkgs.zsh;
    };
    home-manager.users.${user} = import ../../home;

    environment.systemPackages = with pkgs; [
      bluez
    ];

    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Use networkmanager, which supercedes wireless
    networking.networkmanager.enable = true;
    networking.wireless.enable = false;

    networking.useDHCP = false;
    networking.interfaces.enp4s0.useDHCP = lib.mkDefault true;
    networking.interfaces.wlp5s0.useDHCP = lib.mkDefault true;

    time.timeZone = "US/Eastern";

    security.rtkit.enable = true;

    environment.etc = {
      "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
        		bluez_monitor.properties = {
        			["bluez5.enable-sbc-xq"] = true,
        			["bluez5.enable-msbc"] = true,
        			["bluez5.enable-hw-volume"] = true,
        			["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
        		}
        	'';
    };

    services.blueman.enable = false;
    services.openssh.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    services.pipewire.audio.enable = true;
    services.printing.enable = true;
    services.xserver.enable = true;
    services.xserver.layout = "us";
    services.xserver.libinput.enable = true; # Touchpad support
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.desktopManager.plasma5.enable = true;

    sound.enable = true;
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    # hardware.bluetooth.settings = {
    #   General = {
    #     Enable = "Source,Sink,Media,Socket";
    #     Experimental = false;
    #   };
    # };
    hardware.pulseaudio = {
      enable = false;
      # NixOS allows either a lightweight build (default) or full build of PulseAudio to be installed.
      # Only the full build has Bluetooth support, so it must be selected here.
      package = pkgs.pulseaudioFull;
    };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "20.03"; # Did you read the comment?
  };
in
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = inputs;
  modules = [ local ];
}
