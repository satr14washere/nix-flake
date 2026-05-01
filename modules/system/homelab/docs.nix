{ homelab, ... }: let
  domain = "docs.${homelab.domain}";
  sandbox = "docs-sandbox.${homelab.domain}";
  data-dir = "/mnt/data/apps/cryptpad";
in {
  services.cryptpad = {
    enable = true;
    settings = {
      httpPort = 7090;
      httpAddress = "127.0.0.1";
      httpUnsafeOrigin = "https://${domain}";
      httpSafeOrigin = "https://${sandbox}";
      blockDailyCheck = true;
      disableIntegratedEviction = true;
    };
  };
  
  fileSystems."/var/lib/cryptpad" = {
    device = "/mnt/data/apps/cryptpad";
    dependsOn = [ "/mnt/data" ]; 
    options = [ "bind" "nofail" ];
  };
}
