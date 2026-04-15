{ username, ctp-opt, ... }: {
  imports = [
    ./core/shell.nix
    ./core/cli.nix
  ];
  
  catppuccin = {
    enable = true;
    hyprlock.useDefaultConfig = false;
    
    flavor = ctp-opt.flavor;
    accent = ctp-opt.accent;
  };

  home = {
    stateVersion = "24.11";
    username = "${username}";
    homeDirectory = "/home/${username}";
  };
}
