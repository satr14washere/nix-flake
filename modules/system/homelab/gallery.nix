{ homelab, ... }: {
  users.users.immich.extraGroups = [ "video" "render" ];

  services = {
    immich = {
      enable = true;
      port = 2283;
      host = "127.0.0.1";
      mediaLocation = "/mnt/gallery";
      accelerationDevices = null;
      machine-learning.enable = true;
      redis.enable = true;
      settings = {
        newVersionCheck.enabled = true;
        server.externalDomain = "https://gallery.${homelab.domain}";
      };
    };
    immich-public-proxy = {
      enable = true;
      port = 2284;
      immichUrl = "http://localhost:2283";
    };
  };
}