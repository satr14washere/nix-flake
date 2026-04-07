{ pkgs, username, resume-dev, ... }: {
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
    cron = {
      enable = true;
      systemCronJobs = [
        "* * * * * ${username} bash -x ${pkgs.writeShellScript "low-battery-notifier" ''
          BAT_PCT=`${pkgs.acpi}/bin/acpi -b | ${pkgs.gnugrep}/bin/grep -P -o '[0-9]+(?=%)'`
          BAT_STA=`${pkgs.acpi}/bin/acpi -b | ${pkgs.gnugrep}/bin/grep -P -o '\w+(?=,)'`
          echo "`date` battery status:$BAT_STA percentage:$BAT_PCT"
          test $BAT_PCT -le 30 && test $BAT_PCT -gt 15 && test $BAT_STA = "Discharging" && DISPLAY=:0.0 ${pkgs.libnotify}/bin/notify-send -c device -u normal   "Low Battery" "Battery remaining: $BAT_PCT%."
          test $BAT_PCT -le 15                         && test $BAT_STA = "Discharging" && DISPLAY=:0.0 ${pkgs.libnotify}/bin/notify-send -c device -u critical "Low Battery" "Shutdown at 10%."
        ''} > /tmp/cron.batt.log 2>&1"
      ];
    };
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
