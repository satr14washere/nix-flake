{ pkgs, resume-dev, ... }: {
  powerManagement.powertop.enable = true;

  services = {
    udev.extraRules = ''
      #ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="auto"
      ACTION=="add", SUBSYSTEM=="pci", TEST=="power/control", ATTR{power/control}="auto"
      SUBSYSTEM=="power_supply", ACTION=="change", RUN+="${pkgs.writeShellScript "battery-thresholds" ''
        echo 80 > /sys/class/power_supply/BAT*/charge_control_start_threshold || true
        echo 85 > /sys/class/power_supply/BAT*/charge_control_end_threshold || true
      ''}"
    '';
    upower = {
      enable = true;
      percentageCritical = 15;
      percentageAction = 10;
      usePercentageForPolicy = true;
      allowRiskyCriticalPowerAction = false;
      criticalPowerAction = if resume-dev != "" then "Hibernate" else "PowerOff";
    };
  };
}
