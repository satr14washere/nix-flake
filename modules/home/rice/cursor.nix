{ pkgs, ctp-opt, ... }: {
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.catppuccin-cursors."${ctp-opt.flavor}Light";
    name = "catppuccin-${ctp-opt.flavor}-light-cursors";
    size = 24;
  };
}