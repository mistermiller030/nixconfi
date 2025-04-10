{
  modulesPath,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
    ./n8n.nix
  ];
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  nixpkgs.config.allowUnfree = true;

  services.openssh.enable = true;

  services.comin = {
    enable = true;
    remotes = [
      {
        name = "origin";
        url = "https://github.com/mistermiller030/nixconfi.git";
        branches.main.name = "main";
      }
    ];
  };

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    # change this to your ssh key
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDt0V/tN2Z5w1+pdNazA5jETfHfF2YsnKL0eW9YU/ghvPf55ZtK/SWSapUk4RHG6nzQ0SA7edXFiB0JgM22nS9be6Twu6kjTZiqiooZfpZl9Ti3pk99/4O4Md0O8eO/E9zA2En5dU1PwTkFGYziEHi3Iams+ZotFVZxjoJtAJ331KkIq1iFB+dN8c5N4RBLOCLv9wNzd1Lm9I0fUzsodyajNsuMWOpmfqxKw8fmQLrahF+NZ3OKPMI2rzbWhX2I97CsydCya/w6rBjtugUAZ1HQLXEm3JQnBILuu//uYZAyuwV1/UBbIjkb4mMEG6fmK5ymTF/AKV3ow6OF3GO0G5n7L26MrhgU9nXr75HaxDn/B3MRuqEVROf8V0dKaTzX4CqOEUxIfVc+r0MCipE6T9ap48ynWaceZhriwDTmaENmGHxiI5LkOyrg1v2jDECF6znQ6IBR3AY8Q+lu9CexNbNd8Duvgprcvf+p+onoszPcUZjSTz1jCoXlmQRVWWZBGE3Yd/SX+DUfcJj61VKW6SV8Yx8RdLJryfXocPA1CJrT3m4IWM+OxACcdps9UiFB5izxmPB601DB/DqrEpJWCJYjQqrJIdGs08VzB0g2pRNy/aOG1/gwfInrWhGG0ROgoNnicskSs8Eee/cjwDtLrw9HZjZ8+zEfcWippBaVT6zAHw== info@umzug-berlin.de"
  ];

  networking.hostName = "hetzner1";

  system.stateVersion = "24.05";
}
