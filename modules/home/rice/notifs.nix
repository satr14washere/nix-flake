{ pkgs, rice, ... }: {
  services.dunst = {
    enable = true;
    settings.global = {
      font = "${rice.font} 8";
      width = 300;
      origin = "${if rice.bar.top then "top" else "bottom"}-right";
      offset = "${toString rice.gap.outer}x${toString rice.gap.outer}";
      corner_radius = rice.borders.rounded;
      frame_width = rice.borders.size;
      notification_limit = 0;
      mouse_left_click = "close_current";
      mouse_middle_click = "do_action";
      mouse_right_click = "context";
    };
  };

  home.packages = with pkgs; [
    dunst
  ];
}