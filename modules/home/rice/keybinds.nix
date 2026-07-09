{ hostname, ... }: {
  programs.niri.settings.binds = {
    "XF86AudioRaiseVolume" = { action.spawn = [ "wpctl" "set-volume" "-l" "1" "@DEFAULT_AUDIO_SINK@" "5%+" ]; allow-when-locked = true; };
    "XF86AudioLowerVolume" = { action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-" ]; allow-when-locked = true; };
    "XF86AudioMute" = { action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle" ]; allow-when-locked = true; };
    "XF86AudioMicMute" = { action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle" ]; allow-when-locked = true; };
    "XF86MonBrightnessUp" = { action.spawn = [ "brightnessctl" "s" "10%+" ]; allow-when-locked = true; };
    "XF86MonBrightnessDown" = { action.spawn = [ "brightnessctl" "s" "10%-" ]; allow-when-locked = true; };
    
    "Mod+Q".action.close-window = {};
    "Mod+W".action.maximize-column = {};
    "Mod+S".action.fullscreen-window = {};
    "Alt+Print".action.screenshot-window = {};
    "Print".action.screenshot-screen = {};
    
    "Mod+Up".action.focus-workspace-up = {};
    "Mod+Down".action.focus-workspace-down = {};
    "Mod+Left".action.focus-column-left = {};
    "Mod+Right".action.focus-column-right = {};

    "Mod+Shift+Up".action.move-window-up-or-to-workspace-up = {};
    "Mod+Shift+Down".action.move-window-down-or-to-workspace-down = {};
    "Mod+Shift+Left".action.move-column-left = {};
    "Mod+Shift+Right".action.move-column-right = {};

    "Mod+G".action.center-column = {};
    "Mod+F".action.toggle-window-floating = {};
    "Alt+Space".action.toggle-overview = {};
    
    "Mod+Space" = { action.spawn = [ "playerctl" "play-pause" ]; allow-when-locked = true; };
    "Mod+R".action.spawn = [ "rofi" "-show" "drun" "-show-icons" "-display-drun" "" "-run-command" "uwsm app -- {cmd}" ];
    
    "Mod+E".action.spawn = [ "pcmanfm-qt" ];
    "Mod+T".action.spawn = [ "kitty" ];
    "Mod+Y".action.spawn = [ "brave" "--restore-last-session" ];
    "Mod+Return".action.spawn-sh = "ls ~/Projects | rofi -dmenu -p \"Open Project\" | xargs -I {} sh -c 'mkdir -p ~/Projects/\"{}\" && zeditor ~/Projects/\"{}\"'";

    "Mod+M".action.spawn = [ "wlogout" ];
    "Mod+Tab".action.spawn = [ "pkill" "-SIGUSR1" "waybar" ];
    "Mod+H".action.show-hotkey-overlay = {};

    "XF86Bluetooth".action.spawn = [ "blueman-manager" ];
    "XF86Display".action.spawn = [ "nwg-displays" ];
    "Ctrl+Alt+Delete".action.spawn = [ "wlogout" ];
    "Ctrl+Shift+Escape".action.spawn = [ "kitty" "btop" ];
    "Mod+Grave".action.spawn = [ "dunstctl" "set-paused" "toggle" ];

    "Mod+N".action.spawn = [ "rofi-network-manager" ];
    "Mod+J".action.spawn-sh = "notify-send -u critical ${hostname} 'Caffein Mode' && notify-send '(SUPER+X to reset)' && systemctl --user stop hypridle";
    "Mod+Z".action.spawn = [ "dunstctl" "close-all" ];

    "Mod+V".action.spawn = [ "rofi" "-modi" "clipboard:cliphist-rofi-img" "-show" "clipboard" "-show-icons" ];
    "Mod+A".action.spawn = [ "zeditor" ];
    "Mod+C".action.spawn = [ "kitty" "btop" ];
    "Mod+Shift+C".action.spawn = [ "kitty" "zsh" "-c" "fastfetch; exec zsh -i" ];
    "Mod+Shift+D".action.spawn = [ "steam" "-system-composer" "steam://open/bigpicture" ];
    "Mod+D".action.spawn = [ "prismlauncher" ];

    "Mod+X".action.spawn-sh = "dunstctl close-all && pkill -SIGUSR2 waybar && systemctl --user restart awww hypridle";
    "Mod+K".action.spawn-sh = "notify-send -u critical ${hostname} 'Focus Mode' && notify-send '(SUPER+X to reset)' && systemctl --user stop awww && pkill -SIGUSR1 waybar";
    "Mod+L".action.spawn = [ "loginctl" "lock-session" ];
  };
  
  wayland.windowManager.hyprland = {
    settings = {
      gestures = {
        #workspace_swipe = true;
        workspace_swipe_forever = true;
      };

      # gesture = [
      #   "3, up, fullscreen, maximize"
      #   "3, down, scale: 0.5, special, hidden"
      #   "3, left, workspace, -1"
      #   "3, right, workspace, +1"
      # ];

      binde = [
        "ALT, TAB, cyclenext,"
        "ALT, TAB, bringactivetotop,"
        "ALT SHIFT, TAB, cyclenext, prev"
        "ALT SHIFT, TAB, bringactivetotop,"

        "SUPER SHIFT, right, movetoworkspace, +1"
        "SUPER SHIFT, left, movetoworkspace, -1"
        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"

        "SUPER, right, workspace, +1"
        "SUPER, left, workspace, -1"
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
      ];

      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];

      bindc = [
        "SUPER, mouse:274, killactive"
      ];
      
      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];

      bindl = [
        ", switch:on:Lid Switch, exec, systemctl suspend"
        "SUPER, SPACE, exec, playerctl play-pause"
        # "SUPER, M, exec, wlogout"
        # "SUPER, TAB, exec, pkill -SIGUSR1 waybar"
      ];
      
      bind = [
        "SUPER, M, exec, wlogout"
        "SUPER, TAB, exec, pkill -SIGUSR1 waybar"
        
        ",XF86Favorites, togglespecialworkspace, x"
        ",XF86Bluetooth, exec, [float; size 75%] uwsm app -- blueman-manager"
        ",XF86Keyboard, exec, hyprctl dispatch submap reset"
        # ",XF86Tools, exec, "

        ",XF86Display, exec, [float; size 75%] uwsm app -- nwg-displays"
        "CTRL ALT, DELETE, exec, wlogout"
        "CTRL SHIFT, ESCAPE, exec, [float; size 75%] uwsm app -- kitty btop"
        "SUPER, Grave, exec, dunstctl set-paused toggle"

        "SUPER, N, exec, uwsm app -- rofi-network-manager"

        "SUPER, J, exec, notify-send -u critical ${hostname} 'Caffein Mode' && notify-send '(SUPER+X to reset)' && systemctl --user stop hypridle"
        "SUPER, K, exec, notify-send -u critical ${hostname} 'Focus Mode' && notify-send '(SUPER+X to reset)' && systemctl --user stop awww && pkill -SIGUSR1 waybar && hyprctl --batch 'keyword decoration:inactive_opacity 1.0; keyword decoration:blur:enabled 0; keyword general:gaps_in 0; keyword general:gaps_out 0; keyword general:border_size 1; keyword decoration:rounding 0; keyword decoration:shadow:enabled false'"
        "SUPER, B, submap, disabled-all-keybinds"
        "SUPER, H, exec, notify-send ${hostname} 'Animations Off' && hyprctl keyword animations:enabled 0"
        "SUPER, X, exec, dunstctl close-all && hyprctl reload && hyprctl dispatch submap reset && pkill -SIGUSR2 waybar && systemctl --user restart awww hypridle fusuma"
        "SUPER, Z, exec, dunstctl close-all"

        "SUPER SHIFT, S, exec, hyprshot -zm region -o ~/Pictures/Screenshots; killall -9 hyprpicker hyprshot"
        "ALT, PRINT, exec, hyprshot -zm output -o ~/Pictures/Screenshots; killall -9 hyprpicker hyprshot"
        ", PRINT, exec, hyprshot -zm region -o ~/Pictures/Screenshots; killall -9 hyprpicker hyprshot"

        "SUPER, R, exec, rofi -show drun -show-icons -display-drun '' -run-command \"uwsm app -- {cmd}\""
        "SUPER, RETURN, exec, ls ~/Projects | rofi -dmenu -p \"Open Project\" | xargs -I {} sh -c 'mkdir -p ~/Projects/\"{}\" && zeditor ~/Projects/\"{}\"'"
        "SUPER, V, exec, rofi -modi clipboard:cliphist-rofi-img -show clipboard -show-icons"
        # "SUPER, B, exec, rofi -show calc -modi calc -no-show-match -no-sort"

        "SUPER, A, exec, uwsm app -- zeditor"
        "SUPER, T, exec, uwsm app -- kitty"
        "SUPER, E, exec, uwsm app -- pcmanfm-qt ~" # kitty ranger ~"
        "SUPER, C, exec, [float; size 75%] uwsm app -- kitty btop"
        "SUPER SHIFT, C, exec, [float; size 75%] uwsm app -- kitty zsh -c 'fastfetch; exec zsh -i'"
        "SUPER, Y, exec, uwsm app -- brave --restore-last-session"
        "SUPER, D, exec, uwsm app -- steam steam://open/bigpicture"
        "SUPER SHIFT, D, exec, uwsm app -- steam"

        "SUPER, Q, killactive,"
        "SUPER SHIFT, Q, forcekillactive,"
        "SUPER, W, fullscreen, 1"
        "SUPER, S, fullscreen, 0"
        "SUPER, F, togglefloating,"
        "SUPER, G, layoutmsg, togglesplit"
        "SUPER, L, exec, loginctl lock-session"
        "SUPER SHIFT, L, exec, hyprctl dispatch dpms off && loginctl lock-session && sleep 1 && hyprctl dispatch dpms on"
        
        "SUPER, down, togglespecialworkspace, hidden"
        "SUPER SHIFT, down, movetoworkspace, special:hidden"
        "SUPER SHIFT, up, movetoworkspace, +0"

        "SUPER, P, submap, move"
        "SUPER, O, submap, resize"
        "SUPER, I, submap, focus"
        "SUPER, U, submap, swap"
      ];
    };

    extraConfig = ''
      submap = move
      binde = , right, movewindow, r
      binde = , left, movewindow, l
      binde = , up, movewindow, u
      binde = , down, movewindow, d
      bind = , catchall, submap, reset

      submap = resize
      binde = , right, resizeactive, 10 0
      binde = , left, resizeactive, -10 0
      binde = , up, resizeactive, 0 -10
      binde = , down, resizeactive, 0 10
      bind = , catchall, submap, reset

      submap = swap
      bind = , right, swapwindow, r
      bind = , left, swapwindow, l
      bind = , up, swapwindow, u
      bind = , down, swapwindow, d
      bind = , catchall, submap, reset

      submap = focus
      bind = , right, movefocus, r
      bind = , left, movefocus, l
      bind = , up, movefocus, u
      bind = , down, movefocus, d
      bind = , catchall, submap, reset

      submap = disabled-all-keybinds
      bind = , ESCAPE, submap, reset

      submap = reset
    ''; # https://github.com/nix-community/home-manager/issues/6062
  };
}