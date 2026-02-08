{ pkgs, ... }: {
  imports = [
    ./rice/hyprland.nix
    ./rice/hyprlock.nix
    ./rice/waybar.nix
    ./rice/rofi.nix
    ./rice/wlogout.nix
    ./rice/hypridle.nix
    ./rice/dunst.nix
    ./rice/cursor.nix
    ./rice/theme.nix
    ./rice/keybinds.nix
  ];

  services = {
    swww.enable = true;
    hyprpolkitagent.enable = true;
  };

  home = {
    packages = with pkgs; [
      playerctl brightnessctl
      networkmanagerapplet
      qt6Packages.qt6ct kdePackages.qtstyleplugin-kvantum
      nwg-displays
      lxqt.pcmanfm-qt
      hyprshot wl-clipboard cliphist
    ];
  };
}
