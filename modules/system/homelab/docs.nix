{ homelab, ... }: let
  domain = "docs.${homelab.domain}";
  sandbox = "docs-sandbox.${homelab.domain}";
in {
  services.cryptpad = {
    enable = true;
    settings = {
      websocketPort = 7091;
      httpPort = 7090;
      httpAddress = "127.0.0.1";
      httpUnsafeOrigin = "https://${domain}";
      httpSafeOrigin = "https://${sandbox}";
      blockDailyCheck = true;
      disableIntegratedEviction = true;
      disableAnonymousStore = true;
      disableAnonymousPadCreation = true;
      adminKeys = [ 
        "[satr14@docs.satr14.my.id/f1A82fmBuqQka2bNqrCb1WbB9r2ex5A3rdys5xLX3Hc=]"
      ];
    };
  };
  
  fileSystems."/var/lib/private/cryptpad" = {
    device = "/mnt/data/apps/cryptpad";
    depends = [ "/mnt/data" ]; 
    options = [ "bind" "nofail" ];
    fsType = "none";
  };
}
