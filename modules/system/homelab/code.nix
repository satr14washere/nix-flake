{ username, ... }: {
  services.code-server = {
    enable = true;
    host = "127.0.0.1";
    port = 8443;
    user = username;
    auth = "none";
    disableTelemetry = true;
    extensionsDir = "/mnt/data/apps/code-server/extensions";
    userDataDir = "/mnt/data/apps/code-server/user-data";
  };
}
