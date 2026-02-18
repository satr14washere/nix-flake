{ pkgs, ... }: {
  imports = [
    ./misc/battery-power.nix
    ./misc/power-button.nix
    ./misc/cpu-thermal.nix
    ./misc/tzupdate.nix
    ./core/hibernation.nix
    ./core/firmware.nix
    ./core/igpu.nix
    ./core/tpm.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages;
    kernel.sysctl."vm.laptop_mode" = 5;
    initrd.availableKernelModules = [ "thinkpad_acpi" ];
  };
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  services.hardware.bolt.enable = true;
}
