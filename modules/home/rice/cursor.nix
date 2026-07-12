{ lib, pkgs, ctp-opt, ... }: {
  catppuccin.cursors.enable = false; # managed manually below to use the "Light" cursor variant

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    package = pkgs.catppuccin-cursors."${ctp-opt.flavor}Light";
    name = lib.mkOverride 30 "catppuccin-${ctp-opt.flavor}-light-cursors";
    size = 24;
  };
}
