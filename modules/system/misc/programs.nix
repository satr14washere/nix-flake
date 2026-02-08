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
      drivers = with pkgs; [ hplip ];
    };
  };

  programs = {
    steam.enable = true;
    gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
    appimage = {
      enable = true;
      binfmt = true;
    };
  };
}