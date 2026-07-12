{ pkgs, ... }: let
  version = "v1.20.18";
  executable = pkgs.fetchurl {
    url = "https://github.com/9001/copyparty/releases/download/${version}/copyparty-en.py";
    hash = "sha256-8SBrKaLPat80n8sONKQYFeFSQXUnCYtwcOU7SR52h7E=";
  }; 
in {
  systemd.services.copyparty = {
    description = "File Sharing Service";
    enable = true;
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      # ExecStart = "${pkgs.copyparty-most}/bin/copyparty -c /mnt/share/cfg/files.conf";
      ExecStart = "${pkgs.python3}/bin/python3 ${executable} -c /mnt/share/cfg/files.conf";
      Restart = "on-failure";
    };
  };
}
