{ pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;
  
  home = {
    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "brave";
      TERMINAL = "kitty";
    };
    packages = with pkgs; [
      vscode # lets see how long you survive as my default code editor
      zed-editor

      discord
      slack
      brave

      appimage-run
      #winboat
      libreoffice
      #keepassxc
      vlc
      remmina
      moonlight-qt
      kdePackages.kdenlive
      arduino-ide
      inkscape
      #davinci-resolve

      (wrapOBS {
        plugins = with obs-studio-plugins; [
          wlrobs
          obs-backgroundremoval
          obs-pipewire-audio-capture
        ];
      })

      portablemc
      ferium
      virt-manager

      # CLI tools moved to core/cli.nix
      go
      bun
      #nodejs # pkgs.buildEnv error: two given paths contain a conflicting subpath
      nodePackages.npm
      nodePackages.pnpm
      nodePackages.yarn
      python314
      jdk25_headless
      arduino-cli
    ];
  };
}