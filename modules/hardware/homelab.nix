{ ... }: {
  imports = [
    ./core/firmware.nix
    ./core/igpu.nix
    ./misc/disks.nix
    ./misc/serial.nix
  ];
  
  boot.initrd.availableKernelModules = [ "virtio_net" "virtio_pci" "virtio_mmio" "virtio_blk" "virtio_scsi" "virtio_console" ]; 
  services = {
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
  };
}
