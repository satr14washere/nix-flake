{ lib, homelab, ... }: {
  users.users.immich.extraGroups = [ "video" "render" ];

  services = {
    immich = {
      enable = true;
      port = 2283;
      host = "127.0.0.1";
      mediaLocation = "/mnt/gallery";
      accelerationDevices = null;
      environment.DB_URL = lib.mkForce "postgresql:///immich?host=/var/run/postgresql&user=immich"; # https://github.com/immich-app/immich/issues/26140
      machine-learning.enable = true;
      redis.enable = true;
      # settings = {
      #   newVersionCheck.enabled = true;
      #   server.externalDomain = "https://gallery.${homelab.domain}";
      # };
    };
    immich-public-proxy = {
      enable = true;
      port = 2284;
      immichUrl = "http://localhost:2283";
    };
  };
}