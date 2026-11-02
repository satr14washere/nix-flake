{ pkgs, ... }: let
  zoom-wrapper = pkgs.writeShellApplication {
    name = "zoom-us";
    runtimeInputs = with pkgs; [ systemd gnugrep gnused zoom-us ];
    text = ''
      conf="$HOME/.config/zoomus.conf"
      mkdir -p "$(dirname "$conf")"
      touch "$conf"
      sed -i '/^disableCef=/d; /^\[General\]/a disableCef=true' "$conf"
      grep -q '^disableCef=true' "$conf" || printf '[General]\ndisableCef=true\n' >> "$conf"
      exec systemd-run --user --scope --quiet --collect -p MemoryMax=6G -p MemorySwapMax=0 zoom "$@"
    '';
  };
  zoom-capped = pkgs.symlinkJoin {
    name = "zoom-us-capped";
    paths = [ pkgs.zoom-us ];
    postBuild = ''
      rm $out/bin/{zoom,zoom-us} $out/share/applications/Zoom.desktop
      ln -s ${zoom-wrapper}/bin/zoom-us $out/bin/zoom-us
      ln -s zoom-us $out/bin/zoom
      substitute ${pkgs.zoom-us}/share/applications/Zoom.desktop $out/share/applications/Zoom.desktop \
        --replace-fail Exec=zoom Exec=zoom-us
    '';
  };
in {
  nixpkgs.config.allowUnfree = true;

  xdg = {
    autostart.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/plain" = "nvim.desktop";
        "text/html" = "brave-browser.desktop";
        "application/pdf" = "brave-browser.desktop";
        "x-scheme-handler/http" = "brave-browser.desktop";
        "x-scheme-handler/https" = "brave-browser.desktop";
        "x-terminal-emulator" = "kitty.desktop";
        "inode/directory" = "pcmanfm-qt.desktop";
        "audio/mpeg" = "vlc.desktop";
        "audio/mp3" = "vlc.desktop";
        "audio/wav" = "vlc.desktop";
        "audio/flac" = "vlc.desktop";
        "video/mp4" = "vlc.desktop";
        "video/x-matroska" = "vlc.desktop";
        "video/webm" = "vlc.desktop";
        "video/x-msvideo" = "vlc.desktop";
      };
    };
  };
  
  home.packages = with pkgs; [
    zed-editor
    kicad
    opencode
    github-copilot-cli

    slack
    zoom-capped
    vesktop
    
    vlc
    brave
    flameshot
    libreoffice
    appimage-run
    kdePackages.kdenlive

    virt-manager
    remmina
    moonlight-qt
    gpu-screen-recorder
    gpu-screen-recorder-gtk

    # LOCK IN
    (prismlauncher.override {
      jdks = with javaPackages.compiler.temurin-bin; [ jre-21 jdk-25 ];
    })
  ];
}
