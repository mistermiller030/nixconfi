{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Allow unfree packages (necessary for ThinkPad firmware)
  nixpkgs.config.allowUnfree = true;

  # Network configuration
  networking.hostName = "thinkpad"; # Set your hostname
  networking.networkmanager.enable = true;  # Use NetworkManager for Wi-Fi

  # Set your time zone
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties
  i18n.defaultLocale = "de_DE.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  # Enable the X11 windowing system
  services.xserver.enable = true;
  
  # Configure keymap in X11
  services.xserver.layout = "de";
  services.xserver.xkbOptions = "eurosign:e";

  # Enable GNOME Desktop Environment
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # ThinkPad-specific settings
  hardware.enableAllFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.trackpoint.enable = true;
  hardware.trackpoint.emulateWheel = true;

  # Energy management for better battery life
  services.thermald.enable = true;
  services.tlp.enable = true;
  services.tlp.settings = {
    CPU_SCALING_GOVERNOR_ON_AC = "performance";
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  };

  # Enable touchpad support
  services.xserver.libinput.enable = true;

  # Define your user account
  users.users.david = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    initialPassword = "changeme";  # Remember to change this after first login
  };

  # Enable ZSH
  programs.zsh.enable = true;
  users.users.david.shell = pkgs.zsh;

  # Home Manager configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.david = {
      home.stateVersion = "24.11";
      # We'll set this up after the initial installation
    };
  };

  # Install basic system packages
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    firefox
    gnome.gnome-terminal
    eza
    bat
    acpi
    powertop
  ];

  # This value determines the NixOS release with which your system is to be compatible
  system.stateVersion = "24.11"; # DO NOT CHANGE
}
