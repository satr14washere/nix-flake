{ pkgs, ... }: {
  services = {
    sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };
    printing = {
      enable = true;
      drivers = with pkgs; [
        hplip 
        hplipWithPlugin
      ];
    };
  };

  programs = {
    # LOCK IN
    steam.enable = true;
    gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
    appimage = {
      enable = true;
      binfmt = true;
    };
  };
}