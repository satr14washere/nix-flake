{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    jellyfin jellyfin-web jellyfin-ffmpeg
  ];
  services = {
    jellyfin = {
      enable = true;
      dataDir = "/mnt/data/apps/jellyfin";
      hardwareAcceleration = {
        enable = true;
        device = "/dev/dri/renderD128";
      };
    };
    # jellyseerr = {
    #   enable = true;
    #   port = 5055;
    # };
    # radarr = {
    #   enable = true;
    #   settings = {
    #     server = {
    #       port = 7878;
    #       bindaddress = "127.0.0.1";
    #     };
    #   };
    # };
    # sonarr = {
    #   enable = true;
    #   server = {
    #     port = 8989;
    #     bindaddress = "127.0.0.1";
    #   };
    # };
    # qbittorrent = {
    #   enable = true;
    #   webuiPort = 8020;
    # };
    # jackett = {
    #   enable = true;
    #   port = 9117;
    # };
    # flaresolverr = {
    #   enable = true;
    #   port = 8191;
    # };
  };
}
