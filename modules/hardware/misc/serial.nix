{ ... }: let
  serial = "0";
in {
  boot.kernelParams = [ "console=ttyS${serial},115200" ];
  systemd.services."serial-getty@ttyS${serial}" = {
    enable = true;
    wantedBy = [ "getty.target" ];
    serviceConfig.Restart = "always";
  };
}