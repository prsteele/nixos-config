{ local-config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  users.users.${local-config.user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkManager" ];
  };

  environment.systemPackages = with pkgs; [
    bluez
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.networkmanager.enable = true;
  networking.wireless.enable = false; # Enables wireless support via wpa_supplicant.
  networking.useDHCP = false;
  networking.interfaces.enp4s0.useDHCP = true;
  networking.interfaces.wlp5s0.useDHCP = true;

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
}
