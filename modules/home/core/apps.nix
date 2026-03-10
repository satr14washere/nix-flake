{ pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
      vscode # lets see how long you survive as my default code editor
      zed-editor

      discord
      slack
      brave
      modrinth-app

      appimage-run
      # winboat
      libreoffice
      # keepassxc
      # kicad-small
      vlc
      remmina
      moonlight-qt
      kdePackages.kdenlive
      # arduino-ide
      # inkscape
      rustdesk
      # davinci-resolve

      (wrapOBS {
        plugins = with obs-studio-plugins; [
          wlrobs
          obs-backgroundremoval
          obs-pipewire-audio-capture
        ];
      })

      portablemc
      ferium
      steamguard-cli
      virt-manager
    ];
}
