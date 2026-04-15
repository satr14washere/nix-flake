{ ... }: {
  imports = [
    ./misc/cpu-hotplug.nix
    ./misc/serial.nix 
    ./misc/qemu-virtio.nix
    # ^^ only used if vm
    
    ./core/firmware.nix
    ./core/igpu.nix
    ./misc/disks.nix
  ];
  
}
