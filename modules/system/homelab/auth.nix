{ homelab, ... }: {
  services.pocket-id = {
    enable = true;
    credentials.ENCRYPTION_KEY = "/var/lib/pocket-id/encryption-key";
    settings = {
      PORT = "1411";
      HOST = "127.0.0.1";
      APP_URL = "https://auth.proxy.${homelab.domain}";
      TRUST_PROXY = true;
    };
  };
}