{ lib, homelab, ... }: let
  domain = "docs.${homelab.domain}";
  sandbox = "docs-sandbox.${homelab.domain}";
in {
  systemd.services.cryptpad.confinement.enable = lib.mkForce false;
  
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
    };
  };
  
  fileSystems."/var/lib/cryptpad" = {
    device = "/mnt/data/apps/cryptpad";
    depends = [ "/mnt/data" ]; 
    options = [ "bind" "nofail" ];
    fsType = "none";
  };
}
