{ config, pkgs, rice, ctp-opt, ... }: {
  programs.rofi = {
    enable = true;
    terminal = "${pkgs.kitty}/bin/kitty";
    # location = "top";
    # yoffset = 10;
    theme = let inherit (config.lib.formats.rasi) mkLiteral; in {
      "entry".placeholder = "Search...";
      "scrollbar".border-radius = rice.borders.rounded;
      # "element-icon".size = mkLiteral "2em";
      "*" = {
        font = "${rice.font} 12";
        normal-foreground = mkLiteral "@text";
        alternate-normal-foreground = mkLiteral "@text";
        foreground = mkLiteral "@${ctp-opt.accent}";
        border-color = mkLiteral (if rice.borders.colored then "@foreground" else "@overlay0");
      };
      "window" = {
        border-radius = rice.borders.rounded;
        border = rice.borders.size;
        # fullscreen = true;
      };
      "listview" = {
        columns = 2; # 3;
        lines = 9; # 3;
        fixed-columns = false;
      };
      "element" = {
        border-radius = rice.borders.rounded;
        padding = mkLiteral "4px";
        spacing = mkLiteral "8px";
        # orientation = mkLiteral "vertical";
      };
    };
  };

  home.packages = with pkgs; [
    rofi-network-manager
    rofi-power-menu
    rofi
  ];
}