{ homelab, ... }: let
  globalOpts = {
    fsType = "ext4";
    autoFormat = true;
    autoResize = true;
  };
in {
  fileSystems = {
    "/mnt/share" = globalOpts // {
      device = homelab.disks.share;
    };
    "/mnt/data" = globalOpts // {
      device = homelab.disks.data;
    };
  };
}