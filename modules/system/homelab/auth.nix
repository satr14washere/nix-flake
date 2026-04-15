{ homelab, ... }: {
  services.pocket-id = {
    enable = true;
    credentials.ENCRYPTION_KEY = "/mnt/data/apps/pocketid/encryption-key";
    dataDir = "/mnt/data/apps/pocketid/data";
    settings = {
      PORT = "1411";
      HOST = "127.0.0.1";
      APP_URL = "https://auth.${homelab.domain}";
      TRUST_PROXY = true;
    };
  };
}