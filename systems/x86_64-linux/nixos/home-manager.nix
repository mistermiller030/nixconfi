_: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.nixpc = {
      home.stateVersion = "24.11";
      imports = [ ./home.nix ];

    };

    backupFileExtension = "backup";

  };

}
