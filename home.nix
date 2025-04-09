{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "david";
    userEmail = "david.mueller.bln@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.zsh = {
    enable = true;

    # Die am häufigsten verwendeten Aliase
    shellAliases = {
      #ll = "ls -la --color=auto";
      cat = "${pkgs.bat}/bin/bat";
      ls = "${pkgs.eza}/bin/eza";
      ll = "${pkgs.eza}/bin/eza --all --long --icons=always --git";

      update = "sudo nixos-rebuild switch --flake ~/git/nixconfi#nixos";
      #gs = "git status";
    };

    # Aktiviere die beiden Plugins, die du bereits verwendest
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Oh-My-Zsh aktivieren
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "z"
        "sudo"
      ]; # Die gleichen Plugins, die du bereits verwendest
      theme = "robbyrussell"; # Wenn du das robbyrussell-Theme bevorzugst
    };

    # History-Einstellungen
    history = {
      size = 2000;
      save = 2000;
      ignoreDups = true;
      share = true;
    };

  };
}
