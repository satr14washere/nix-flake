{ pkgs, ... }: {
  imports = [
    ./rice/compositor.nix
    ./rice/lockscreen.nix
    ./rice/keybinds.nix
    ./rice/logout.nix
    ./rice/notifs.nix
    ./rice/cursor.nix
    ./rice/menu.nix
    ./rice/idle.nix
    ./rice/bar.nix
    ./misc/handlers.nix
    ./misc/phone.nix
    ./core/apps.nix
    ./core/code.nix
  ];

  services = {
    awww.enable = true;
    hyprpolkitagent.enable = true;
  };

  home = {
    packages = with pkgs; [
      playerctl brightnessctl
      networkmanagerapplet tailscale-systray
      qt6Packages.qt6ct kdePackages.qtstyleplugin-kvantum
      nwg-displays
      lxqt.pcmanfm-qt
      hyprshot wl-clipboard cliphist
      hyprshutdown
    ];
  };
}
