{ lib, pkgs, ctp-opt, ... }: {
  catppuccin = {
    hyprlock.useDefaultConfig = false;
    hyprland.accent = ctp-opt.primary;
    flavor = ctp-opt.flavor;
    accent = ctp-opt.accent;
    enable = true;
  };
  
  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
    };
  };

  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    iconTheme = {
      name = "Papirus-Dark";
      package = lib.mkForce pkgs.papirus-icon-theme;
    };
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style = {
      name = "kvantum";
      package = pkgs.catppuccin-kvantum.override {
        variant = ctp-opt.flavor;
        accent = ctp-opt.accent;
      };
    };
  };
}