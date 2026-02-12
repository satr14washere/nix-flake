{ ... }: {
  services = {
    thermald.enable = true;
    throttled.enable = true;
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_BOOST_ON_AC = "1";
        
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_BOOST_ON_BAT = "0";
        CPU_MAX_FREQ_ON_BAT = "1500000";
        CPU_MIN_FREQ_ON_BAT = "400000";
        
        START_CHARGE_THRESH_BAT0 = "80";
        STOP_CHARGE_THRESH_BAT0 = "85";
        
        START_CHARGE_THRESH_BAT1 = "80";
        STOP_CHARGE_THRESH_BAT1 = "85";
      };
    };
    auto-cpufreq = {
      enable = false; # replaced with tlp until fix: https://github.com/AdnanHodzic/auto-cpufreq/issues/906
      settings = {
        charger = {
          governor = "performance";
          energy_performance_preference = "performance";
          turbo = "auto";
        };
        battery = {
          governor = "powersave";
          energy_performance_preference = "power";
          turbo = "never";
        };
      };
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
  };
}
