{ config, homelab, ... }: {
  services.vaultwarden = {
    enable = true;
    domain = "pass.proxy.${homelab.domain}";
    backupDir = "/mnt/data/vaultwarden/backups";
    environmentFile = config.sops.secrets.vaultwarden_env.path;
    config = {
      ROCKET_PORT = 8060;
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_LOG = "critical";
      SIGNUPS_ALLOWED = true;
    };
  };
}