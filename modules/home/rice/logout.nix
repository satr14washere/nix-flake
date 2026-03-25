{ rice, ... }: {
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "shutdown";
        action = "hyprshutdown -t 'Shutting down...' --post-cmd 'systemctl poweroff'";
        text = "(S)hutdown";
        keybind = "s";
      }
      {
        label = "reboot";
        action = "hyprshutdown -t 'Rebooting...' --post-cmd 'systemctl reboot'";
        text = "(R)eboot";
        keybind = "r";
      }
      {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "(H)ibernate";
        keybind = "h";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Sus(p)end";
        keybind = "p";
      }
      {
        label = "logout";
        action = "hyprshutdown -t 'Logging Out...' --post-cmd 'uwsm stop'";
        text = "L(o)gout";
        keybind = "o";
      }
      {
        label = "lock";
        action = "loginctl lock-session";
        text = "(L)ock";
        keybind = "l";
      }
    ];
    style = ''
      button {
        border-width: ${toString rice.borders.size}px;
        border-radius: ${toString rice.borders.rounded}px;
        margin: ${toString rice.gap.inner}px;
        font-family: ${rice.font};
      }
    '';
  };
}