{ lib, homelab, ... }: let
  globalOpts = {
    autoFormat = true;
    autoResize = true;
  };
in {
  fileSystems = {
    "/".autoResize = true;
  } // lib.mapAttrs' (name: dev:
    lib.nameValuePair "/mnt/${name}" (globalOpts // {
      device = dev.path;
      fsType = dev.type;
    })
  ) homelab.disks;
}