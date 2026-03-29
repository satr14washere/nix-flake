{ lib, homelab, ... }: let
  globalOpts = {
    fsType = "ext4";
    autoFormat = true;
    autoResize = true;
  };
in {
  fileSystems = {
    "/".autoResize = true;
  } // lib.mapAttrs' (name: dev:
    lib.nameValuePair "/mnt/${name}" (globalOpts // {
      device = dev.path;
      options = if dev.required == false then [
        "nofail"
        "x-systemd.automount"
      ] else [ "defaults" ];
    })
  ) homelab.disks;
}