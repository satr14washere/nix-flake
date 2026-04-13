{ homelab, ... }: let
  domain = "docs.${homelab.domain}";
in {
  services.cryptpad = {
    enable = true;
    settings = {
      httpPort = 7090;
      websocketPort = 7080;
      httpUnsafeOrigin = "https://${domain}";
      httpSafeOrigin = "https://${domain}";
      blockDailyCheck = true;
      disableIntegratedEviction = true;
    };
  };
}