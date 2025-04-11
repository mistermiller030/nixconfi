{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Boot-Loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ThinkPad-spezifische Einstellungen
  hardware.enableAllFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;
  
  # Für TrackPoint
  hardware.trackpoint.enable = true;
  hardware.trackpoint.emulateWheel = true;

  # Energiemanagement
  services.thermald.enable = true;
  services.tlp.enable = true;
  services.tlp.settings = {
    CPU_SCALING_GOVERNOR_ON_AC = "performance";
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  };

  # Netzwerk
  networking.hostName = "thinkpad";
  networking.networkmanager.enable = true;

  # Benutzer
  users.users.david = {  # Ersetze "david" mit deinem Benutzernamen
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    shell = pkgs.zsh;
  };

  # Home Manager - die gleiche Konfiguration wie dein Hauptrechner
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.david = {  # Ersetze "david" mit deinem Benutzernamen
      home.stateVersion = "24.11";
      imports = [ ../../x86_64-linux/nixos/home.nix ];  # Verwendet deine bestehende home.nix
    };
    backupFileExtension = "backup";
  };

  # System-Pakete speziell für den Laptop
  environment.systemPackages = with pkgs; [
    acpi
    powertop
    git
    neovim
    wget
    eza
    bat
  ];

  # Zeitzone und Sprache
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";
  
  # Weitere Einstellungen kannst du nach Bedarf hinzufügen

  system.stateVersion = "24.11";
}
