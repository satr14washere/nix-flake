{ pkgs, rice, ctp-opt, ... }: {
  imports = [
    ./keybinds.nix
  ];

  # TODO: https://github.com/sodiboo/niri-flake/issues/1393 for nwg-displays monitor dynamic config

  programs.niri = {
    settings = {
      outputs."eDP-1" = {
        mode = { width=1920; height=1080; refresh=60.006; };
        position = { x=0; y=0; };
        scale   = 1.0;
      };
      
      environment = {
        XCURSOR_SIZE = "24";
        XCURSOR_THEME = "catppuccin-${ctp-opt.flavor}-light-cursors";

        CLIPHIST_MAX_ITEMS = "36";

        GTK_APPLICATION_PREFER_DARK_THEME = "1";
        GTK_THEME = "Adwaita:dark";
        QT_QPA_PLATFORMTHEME = "kvantum";
        QT_STYLE_OVERRIDE = "kvantum";
      };
      spawn-at-startup = map (sh: { inherit sh; }) [
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"

        "waybar &"
        "sunshine &"
        "blueman-applet &"
        "nm-applet &"
        "tailscale systray &"
      ];

      prefer-no-csd = true;
      layout = {
        tab-indicator.enable = false;
        gaps = rice.gap.outer;
        border = {
          enable = true;
          width = rice.borders.size;
          
        };
      };
    };
  };
  
  catppuccin.hyprland.enable = false; # temp fix until i get things migrated to lua
  
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland; # inputs.hl.packages."${pkgs.system}".hyprland;
    configType = "hyprlang"; # keep legacy config format (home.stateVersion < 26.05)
    systemd.enable = false;
    xwayland.enable = true;
    settings = {
      dwindle.preserve_split = true;
      
      debug = {
        error_position = 1;
        disable_logs = true;
        vfr = true;
      };

      source = [
        "~/.config/hypr/monitors.conf"
        "~/.config/hypr/workspaces.conf"
      ]; # nwg-displays

      exec-once = [
        "hyprctl setcursor catppuccin-mocha-light-cursors 24"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"

        "uwsm app -s s -- waybar &"
        "uwsm app -s b -- sunshine &"
        "uwsm app -s b -- blueman-applet &"
        "uwsm app -s b -- nm-applet &"
        "uwsm app -s b -- tailscale systray &"
      ];

      env = [
        "XCURSOR_SIZE,24"
        "XCURSOR_THEME,catppuccin-${ctp-opt.flavor}-light-cursors"
        "HYPRCURSOR_SIZE,24"
        "HYPRCURSOR_THEME,catppuccin-${ctp-opt.flavor}-light-cursors"

        "CLIPHIST_MAX_ITEMS,36"

        "GTK_APPLICATION_PREFER_DARK_THEME,1"
        "GTK_THEME,Adwaita:dark"
        "QT_QPA_PLATFORMTHEME,kvantum"
        "QT_STYLE_OVERRIDE,kvantum"
      ];

      general = {
        gaps_in = rice.gap.inner;
        gaps_out = rice.gap.outer;
        border_size = rice.borders.size;
        resize_on_border = true;
        allow_tearing = false;
        layout = "dwindle";

        "col.active_border" = if rice.borders.colored then "$accent" else "rgb(108,112,134)"; # accent overlay0
        "col.inactive_border" = if rice.borders.colored then "rgb(147,153,178)" else "rgb(17,17,27)"; # overlay2 crust
      };

      decoration = {
        rounding = rice.borders.rounded;
        rounding_power = 2;
        active_opacity = 1.0;
        inactive_opacity = 0.9;

        shadow = {
          enabled = true;
          range = 6;
          render_power = 3;
          color_inactive = "rgba(17,17,27,99)"; # crust alpha 99
          color = "rgba(17,17,27,238)"; # crust alpha ee
        };

        blur = {
          enabled = true;
          size = 7;
          passes = 3;
          ignore_opacity = true;

          noise = 0.05;
          contrast = 1.5;

          xray = false;
          new_optimizations = true;
        };
      };

      animations = {
        enabled = true;
        #first_launch_animation = false;

        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "quick,0.15,0,0.1,1"
          "overshot,0.05,0.9,0.1,1.1"
          "instant,0,0,1,1"
        ];

        animation = [
          "global, 1, 10, default"
          "fade, 1, 3, quick"
          "border, 1, 10, quick"
          "layers, 1, 5, easeOutQuint, slidevert"
          "windows, 1, 5, easeOutQuint, popin 87%"
          "workspaces, 1, 5, easeOutQuint, slidefade 20%"
          "specialWorkspace, 1, 5, easeOutQuint, slidefadevert ${if rice.bar.top then "" else "-"}20%"
          "zoomFactor, 1, 1, instant"
        ];
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        focus_on_activate = true;
        middle_click_paste = false;
        exit_window_retains_fullscreen = true;
        on_focus_under_fullscreen = 1;
        background_color = "rgb(17, 17, 27)"; # crust
      };

      input = {
        kb_layout = "us";
        kb_options = "caps:none";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
          middle_button_emulation = 0;
        };
      };

      layerrule = [
        "no_anim on, match:namespace selection" # hyprshot overlay
        "no_anim on, match:namespace hyprpicker"
        "animation fade, match:namespace awww-daemon"
        "animation fade, match:namespace logout_dialog"
        "animation fade, match:namespace hyprshutdown"
        "above_lock 2, match:namespace notifications"
        # "above_lock 1, match:namespace waybar"
        # "above_lock 2, match:namespace logout_dialog"
      ];

      windowrule = [
        "suppress_event minimize, match:class .*"
        "no_focus on, match:class ^$, match:title ^$, match:xwayland 1, match:float 1, match:fullscreen 0, match:pin 0"

        "stay_focused on, suppress_event fullscreen maximize, dim_around on, float on, match:title ^(Hyprland Polkit Agent|Unlock Login Keyring|KeePassXC -.*)$"
        "float on, match:title ^(Open|Print|Save|Rename|Move|Copy|Confirm).*"
        "float on, match:title ^(Preferences|Settings|Options|About|Passbolt).*"
        "float on, match:title ^(MainPicker|Volume Control|File Operation Progress|Network Connections|Choose an Application)$"
        "float on, match:title ^(Please wait)$"
      ];
    };
  };
}
