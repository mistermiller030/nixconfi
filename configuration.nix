# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Bucharest";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ro_RO.UTF-8";
    LC_IDENTIFICATION = "ro_RO.UTF-8";
    LC_MEASUREMENT = "ro_RO.UTF-8";
    LC_MONETARY = "ro_RO.UTF-8";
    LC_NAME = "ro_RO.UTF-8";
    LC_NUMERIC = "ro_RO.UTF-8";
    LC_PAPER = "ro_RO.UTF-8";
    LC_TELEPHONE = "ro_RO.UTF-8";
    LC_TIME = "ro_RO.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    audio.enable = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nixpc = {
  isNormalUser = true;
  description = "David Müller";
  extraGroups = [ "networkmanager" "wheel" ];
  shell = pkgs.zsh;
};

programs.zsh = {
  enable = true;
  promptInit = ''
    source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
  '';
  ohMyZsh = {
    enable = true;
    plugins = [ "git" "z" "sudo" ];
  };
};


environment.etc."zshrc.local".text = ''
  source ${pkgs.oh-my-zsh}/share/oh-my-zsh/themes/robbyrussell.zsh-theme
'';

  # Aktivierung von Flatpak als Dienst (so geht’s richtig!)
  services.flatpak.enable = true;

  # Wichtig für Wayland Screensharing
  xdg.portal.enable = true;

  xdg.portal.extraPortals = [ 
  pkgs.xdg-desktop-portal-gnome 
  pkgs.xdg-desktop-portal-gtk
];
  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    neovim
    neofetch
    git
    brave
    kitty
    zsh
    curl
    fira-code-nerdfont
    zsh-powerlevel10k
    usbutils
    pavucontrol
    vlc
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    vesktop
    gnomeExtensions.appindicator # für Status-Icons (empfohlen)
    gnome-tweaks           # Gnome Tweaks (empfohlen)
    gnome-extension-manager      # Der GNOME Extension Manager
    ghostty
    python311
    python311Packages.py
    python311Packages.setuptools
    ripgrep
    nodejs
    fd
    gcc
    wl-clipboard
    #go-bereich
    go
    gopls
    golangci-lint
    delve
    go-tools
    gofumpt
    gomodifytags
    impl
    gotests
    v4l-utils
    remmina
  ];


services.udev.extraRules = ''
  KERNEL=="video[0-9]*", MODE="0666"
'';

boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];

boot.kernelModules = [ "v4l2loopback" ];



  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?


# NVIDIA RTX 4090 Treiber und 4K-Support
services.xserver.videoDrivers = ["nvidia"];

hardware.nvidia = {
  modesetting.enable = true;          # Aktiviert den Modesetting-Modus für bessere Kompatibilität
  powerManagement.enable = true;      # Aktiviert das Power-Management für Energieeffizienz
  open = false;                       # Verwendet den proprietären NVIDIA-Treiber für optimale Leistung
  package = config.boot.kernelPackages.nvidiaPackages.stable;  # Stabile Treiberversion
};

hardware.graphics = {
  enable = true;                      # Aktiviert die Grafikunterstützung
  enable32Bit = true;                 # Unterstützt 32-Bit-Anwendungen
};

# (Optional) 4K-Auflösung erzwingen, falls benötigt:
services.xserver.resolutions = [{ x = 3840; y = 2160; }];
# für das rode mic


}
