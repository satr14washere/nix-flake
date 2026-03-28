{ pkgs, username, ... }: {
  services.code-server = {
    enable = true;
    host = "127.0.0.1";
    port = 8443;
    user = username;
    auth = "none";
    disableTelemetry = true;
    extensionsDir = "/mnt/data/code-server/extensions";
    userDataDir = "/mnt/data/code-server/user-data";
    extraPackages = with pkgs; [];
  };
}
