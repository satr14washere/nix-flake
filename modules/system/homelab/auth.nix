{ homelab, ... }: {
  services.pocket-id = {
    enable = true;
    credentials.ENCRYPTION_KEY = "${homelab.disks.data}/pocketid/encryption-key";
    dataDir = "${homelab.disks.data}/pocketid/data";
    settings = {
      PORT = "1411";
      HOST = "127.0.0.1";
      APP_URL = "https://auth.proxy.${homelab.domain}";
      TRUST_PROXY = true;
    };
  };
}