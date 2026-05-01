{ homelab, ... }: {
  services.vaultwarden = {
    enable = true;
    domain = "pass.proxy.${homelab.domain}";
    backupDir = "/mnt/data/apps/vaultwarden/backups";
    environmentFile = "/mnt/data/apps/vaultwarden/.env";
    config = {
      ROCKET_PORT = 8060;
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_LOG = "critical";
    };
  };
  
  fileSystems."/var/lib/vaultwarden" = {
    device = "/mnt/data/apps/vaultwarden/data";
    depends = [ "/mnt/data" ];
    options = [ "bind" "nofail" ];
  };
}