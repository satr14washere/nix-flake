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
      archivePath = "${data-dir}/archive";
      pinPath = "${data-dir}/pins";
      taskPath = "${data-dir}/tasks";
      blockPath = "${data-dir}/block";
      blobPath = "${data-dir}/blob";
      blobStagingPath = "${data-dir}/blobstage";
      decreePath = "${data-dir}/decrees";
      logPath = "${data-dir}/logs";
    };
  };
  
  systemd.services.cryptpad.serviceConfig = {
    ReadWritePaths = [ data-dir ];
    ProtectMountPoints = false;
  };
}