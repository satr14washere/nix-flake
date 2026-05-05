{ lib, pkgs, ctp-opt, rice, ... }: {
  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = lib.mkForce "Adwaita-dark";
    };
  };

  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.theme = null;
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
    kvantum = {
      enable = true;
      themes = with pkgs; [ catppuccin-kvantum ];
      settings.General.theme = "catppuccin-${ctp-opt.flavor}-${ctp-opt.accent}";
    };
    platformTheme.name = "kvantum";
    style = {
      name = "kvantum";
      package = pkgs.catppuccin-kvantum.override {
        variant = ctp-opt.flavor;
        accent = ctp-opt.accent;
      };
    };
    qt6ctSettings = {
      Appearance = {
        style = "kvantum";
        icon_theme = "Papirus-Dark";
        standar_dialogs = "xdgdesktopportal";
      };
      Fonts = {
        fixed = "${rice.font},12";
        general = "${rice.font},12";
      };
    };
  };
}