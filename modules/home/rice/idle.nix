{ pkgs, ... }: {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "hyprlock";
        unlock_cmd = "pkill -USR1 hyprlock";
        before_sleep_cmd = "niri msg action power-off-monitors && hyprlock";
        after_sleep_cmd = "niri msg action power-on-monitors";
      };
      listener = [
        {
          timeout = 120;
          on-timeout = "brightnessctl s 10%-";
          on-resume = "brightnessctl s +10%";
        }
        {
          timeout = 300;
          on-timeout = "hyprlock";
          on-resume = "pkill -USR2 hyprlock";
        }
        {
          timeout = 420;
          on-timeout = "niri msg action power-off-monitors";
          on-resume = "niri msg action power-on-monitors";
        }
        {
          timeout = 600;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  home.packages = with pkgs; [
    hypridle
  ];
}