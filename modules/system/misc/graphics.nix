{ pkgs, ... }: {
  hardware.graphics = {
    enable = true;
    extraPackages = [ pkgs.libva-vdpau-driver ];
  };

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    blueman.enable = true;
    pulseaudio.enable = false;
  };
  
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.droid-sans-mono
      noto-fonts-cjk-sans
      noto-fonts
      font-awesome
      corefonts
    ];
  };
  
  programs.xfconf.enable = true;
  security.rtkit.enable = true;
}