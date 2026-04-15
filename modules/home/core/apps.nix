{ pkgs, ... }: {
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
    # kicad-small
    # arduino-ide

    slack
    discord
    # protonmail-desktop # https://www.reddit.com/r/NixOS/comments/1rm9alf/protonmail_in_nixos/
    
    vlc
    brave
    flameshot
    libreoffice
    appimage-run
    # keepassxc

    virt-manager
    # winboat
    
    remmina
    moonlight-qt
    # rustdesk
    
    
    # inkscape
    # davinci-resolve
    # kdePackages.kdenlive
    (wrapOBS {
      plugins = with obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
      ];
    })

    ferium
    portablemc
    steamguard-cli
    # modrinth-app
  ];
}
