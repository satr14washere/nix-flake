{ pkgs, enable-dm, ... }: {
  imports = [
    ./misc/programs.nix
    ./misc/graphics.nix
    ./misc/theme.nix
    ./base.nix
  ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
    package = pkgs.hyprland; # if rice.enable then inputs.hl.packages."${pkgs.system}".hyprland else pkgs.hyprland;
    portalPackage = pkgs.xdg-desktop-portal-hyprland; # inputs.hl.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland #inputs.hl.packages.${pkgs.system}.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  services.displayManager.sddm = {
    enable = enable-dm;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;
    extraPackages = with pkgs.kdePackages; [
      qtmultimedia qtsvg
    ];
  };

  environment = {
    systemPackages = with pkgs; [
      libsecret libnotify kdePackages.kdeconnect-kde
    ];
    sessionVariables = {
      XDG_RUNTIME_DIR = "/run/user/$UID"; # https://discourse.nixos.org/t/login-keyring-did-not-get-unlocked-hyprland/40869/10
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
    };
  };
}
