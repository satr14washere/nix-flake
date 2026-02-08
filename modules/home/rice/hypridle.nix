{ pkgs, ... }: {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "hyprlock";
        unlock_cmd = "pkill -USR1 hyprlock";
        before_sleep_cmd = "hyprctl dispatch dpms off && hyprlock";
        after_sleep_cmd = "hyprctl dispatch dpms on && pkill -USR2 hyprlock";
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
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
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