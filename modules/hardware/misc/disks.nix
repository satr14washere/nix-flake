{ lib, homelab, ... }: let
  globalOpts = {
    fsType = "ext4";
    autoFormat = true;
    autoResize = true;
  };
in {
  fileSystems = {
    "/".autoResize = true;
  } // lib.mapAttrs' (name: device:
    lib.nameValuePair "/mnt/${name}" (globalOpts // { inherit device; })
  ) homelab.disks;
}