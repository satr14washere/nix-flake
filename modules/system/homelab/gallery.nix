{ homelab, ... }: {
  users.users.immich.extraGroups = [ "video" "render" ];

  services = {
    immich = {
      enable = true;
      port = 2283;
      host = "127.0.0.1";
      mediaLocation = "${homelab.disks.data}/immich";
      accelerationDevices = null;
      machine-learning.enable = true;
    };
    immich-public-proxy = {
      enable = true;
      port = 2284;
      immichUrl = "http://localhost:2283";
    };
  };
}