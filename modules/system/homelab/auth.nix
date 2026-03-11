{ config, homelab, ... }: {
  services.pocket-id = {
    enable = true;
    credentials.ENCRYPTION_KEY = config.sops.secrets.pocketid_encryption_key.path;
    dataDir = "/mnt/data/pocketid/data";
    settings = {
      PORT = "1411";
      HOST = "127.0.0.1";
      APP_URL = "https://auth.${homelab.domain}";
      TRUST_PROXY = true;
    };
  };
}