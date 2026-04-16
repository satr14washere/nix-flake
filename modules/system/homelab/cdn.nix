{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ copyparty-most ];

  systemd.services.copyparty = {
    description = "File Sharing Service";
    enable = true;
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.copyparty-most}/bin/copyparty -c /mnt/share/cfg/files.conf";
      Restart = "on-failure";
      User = "nobody";
    };
  };
}
