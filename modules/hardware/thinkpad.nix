{ pkgs, ... }: {
  imports = [
    ./misc/battery-power.nix
    ./misc/power-button.nix
    ./misc/cpu-freq.nix
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
    kernelParams = [
      "i915.enable_psr=1"
      "pcie_aspm=force"
      "nmi_watchdog=0"
      # ^^ potential instability, but improves battery life
      
      "loglevel=3"
      "i915.enable_guc=3"
      "i915.enable_fbc=1"
      "msr.allow-writes=on"
      "nvme_core.default_ps_max_latency_us=0"
    ];
  };
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  services = {
    throttled = {
      enable = true;
      extraConfig = ''
        [GENERAL]
        Enabled: True
        Update_Rate_s: 30
    
        [BATTERY]
        Update_Rate_s: 30
        PL1_Tdp_W: 12
        PL1_Duration_s: 28
        PL2_Tdp_W: 20
        PL2_Duration_s: 0.002
        Trip_Temp_C: 85
    
        [AC]
        Update_Rate_s: 5
        PL1_Tdp_W: 25
        PL1_Duration_s: 28
        PL2_Tdp_W: 35
        PL2_Duration_s: 0.002
        Trip_Temp_C: 90
    
        [UNDERVOLT]
        CORE: -100
        CACHE: -100
        GPU: -80
        UNCORE: -80
        ANALOGIO: 0
      '';
    };
    thinkfan = {
      enable = true;
      levels = [
        [ "level auto"       0  55  ]
        [ 3                  55 65  ]
        [ 7                  65 75  ]
        [ "level full-speed" 75 100 ]
      ];
    };
    hardware.bolt.enable = true;
  };
  environment.systemPackages = with pkgs; [
    intel-gpu-tools
    throttled
    tlp
  ];
}
