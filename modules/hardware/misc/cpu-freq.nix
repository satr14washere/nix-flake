{ ... }: {
  services = {
    power-profiles-daemon.enable = false; # replacement for tlp and auto-cpufreq due to bugs
    tlp = {
      enable = false; # buggy and inconsistent with frequency scaling
      settings = {
        TLP_DEFAULT_MODE = "BAL";
        
        CPU_SCALING_GOVERNOR_ON_PRF = "performance";
        CPU_ENERGY_PERF_POLICY_ON_PRF = "performance";
        CPU_BOOST_ON_PRF = "1";
        CPU_MAX_FREQ_ON_PRF = "3600000";
        CPU_MIN_FREQ_ON_PRF = "100000";
        CPU_MIN_PERF_ON_PRF = "40";
        CPU_MAX_PERF_ON_PRF = "100";
        PLATFORM_PROFILE_ON_PRF = "performance";
        MEM_SLEEP_ON_PRF = "s2idle";
        
        CPU_SCALING_GOVERNOR_ON_BAL = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_BAL = "balance_power";
        CPU_BOOST_ON_BAL = "0";
        CPU_MAX_FREQ_ON_BAL = "1700000";
        CPU_MIN_FREQ_ON_BAL = "800000";
        CPU_MIN_PERF_ON_BAL = "40";
        CPU_MAX_PERF_ON_BAL = "80";
        PLATFORM_PROFILE_ON_BAL = "balanced";
        MEM_SLEEP_ON_BAL = "s2idle";
        
        CPU_SCALING_GOVERNOR_ON_SAV = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_SAV = "power";
        CPU_BOOST_ON_SAV = "0";
        CPU_MAX_FREQ_ON_SAV = "1200000";
        CPU_MIN_FREQ_ON_SAV = "400000";
        CPU_MIN_PERF_ON_SAV = "40";
        CPU_MAX_PERF_ON_SAV = "80";
        PLATFORM_PROFILE_ON_SAV = "low-power";
        MEM_SLEEP_ON_SAV = "deep";
        
        WOL_DISABLE = "N";
        DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth wwan";
        DEVICES_TO_ENABLE_ON_STARTUP = "wifi";
        
        START_CHARGE_THRESH_BAT0 = "80";
        STOP_CHARGE_THRESH_BAT0 = "85";
        
        START_CHARGE_THRESH_BAT1 = "80";
        STOP_CHARGE_THRESH_BAT1 = "85";
      };
    };
    auto-cpufreq = {
      enable = true; # wait for fix: https://github.com/AdnanHodzic/auto-cpufreq/issues/906
      settings = {
        charger = {
          governor = "performance";
          energy_performance_preference = "performance";
          turbo = "always";
          platform_profile = "performance";
          scaling_min_freq = 800000;
          scaling_max_freq = 3600000;
        };
        battery = {
          governor = "powersave";
          energy_performance_preference = "balance-power";
          platform_profile = "low-power";
          turbo = "never";
          scaling_min_freq = 400000;
          scaling_max_freq = 1700000;
        };
      };
    };
  };
}
