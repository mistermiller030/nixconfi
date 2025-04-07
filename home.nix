_: {
  programs.git = {
      enable = true;
      userName = "david";
      userEmail = "david.mueller.bln@gmail.com";
      extraConfig = {
          init.defaultBranch = "main";
        };
    };
  }
