{ homelab, ... }: {
  services.vaultwarden = {
    enable = true;
    config = {
      DOMAIN = "https://pass.proxy.${homelab.domain}";
      ROCKET_PORT = 8060;
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_LOG = "critical";
      DATA_FOLDER = "/mnt/data/vaultwarden";
      SIGNUPS_ALLOWED = true;
    };
  };
}