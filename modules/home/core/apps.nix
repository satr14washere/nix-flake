{ pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
      zed-editor
      # kicad-small
      # arduino-ide

      slack
      discord
      protonmail-desktop
      
      vlc
      brave
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
      prismlauncher
      steamguard-cli
      # modrinth-app
    ];
}
