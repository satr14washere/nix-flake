{ homelab, ... }: {
  services.vaultwarden = {
    enable = true;
    domain = "pass.proxy.${homelab.domain}";
    backupDir = "/mnt/data/vaultwarden/backups";
    environmentFile = "/mnt/data/vaultwarden/.env";
    config = {
      ROCKET_PORT = 8060;
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_LOG = "critical";
    };
  };
}