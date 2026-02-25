{ hostname, timezone, locale, ... }: {
  system.stateVersion = "24.11";
  imports = [
    ./core/virtualization.nix
    ./core/bootloader.nix
    ./core/filesystem.nix
    ./core/network.nix
    ./core/kernel.nix
    ./core/shell.nix
    ./misc/utilities.nix
    ./misc/nix-conf.nix
  ];

  networking.hostName = "${hostname}";
  time.timeZone = timezone;
  i18n.defaultLocale = locale;
  environment.localBinInPath = true;

  security = {
    sudo.configFile = ''
      Defaults insults
      Defaults passwd_tries = 5
    '';
  };

  services = {
    openssh.enable = true;
    tailscale.enable = true;
  };
}