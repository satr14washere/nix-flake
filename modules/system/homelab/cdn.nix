{ pkgs, ... }: let
  python = pkgs.python3.withPackages (ps: with ps; [ pillow argon2 ]);
  script = let
    version = "v1.20.18";
  in pkgs.fetchurl {
    url = "https://github.com/9001/copyparty/releases/download/${version}/copyparty-en.py";
    hash = "sha256-8SBrKaLPat80n8sONKQYFeFSQXUnCYtwcOU7SR52h7E=";
  };
  executable = pkgs.writeShellScriptBin "copyparty" ''
    exec ${python}/bin/python3 ${script} "$@"
  '';
in {
  environment.systemPackages = [ executable ];
  systemd.services.copyparty = {
    description = "File Sharing Service";
    enable = true;
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.ffmpeg ];
    serviceConfig = {
      # ExecStart = "${pkgs.copyparty-most}/bin/copyparty -c /mnt/share/cfg/files.conf";
      ExecStart = "${python}/bin/python3 ${script} -c /mnt/share/cfg/files.conf";
      Restart = "on-failure";
    };
  };
}
