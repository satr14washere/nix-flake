{ ctp-opt, ... }: {
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  catppuccin = {
    enable = true;
    flavor = ctp-opt.flavor;
    accent = ctp-opt.accent;
  };
}