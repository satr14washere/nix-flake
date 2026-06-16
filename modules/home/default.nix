{ username, ctp-opt, ... }: {
  imports = [
    ./core/shell.nix
    ./core/cli.nix
  ];
  
  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = ctp-opt.flavor;
    accent = ctp-opt.accent;
    
    hyprlock.useDefaultConfig = false;
    nvim.settings.transparent_background = true;
  };

  home = {
    stateVersion = "24.11";
    username = "${username}";
    homeDirectory = "/home/${username}";
  };
}
