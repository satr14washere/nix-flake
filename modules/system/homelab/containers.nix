{ lib, ... }: let
  stacks-dir = "/opt/stacks";
in {
  virtualisation = {
    oci-containers.backend = "docker";
    docker = {
      enable = true;
      autoPrune.enable = true;
    };
  };

  virtualisation.oci-containers.containers."dockge" = {
    image = "louislam/dockge:latest";
    environment = {
      "DOCKGE_STACKS_DIR" = stacks-dir;
    };
    volumes = [
      "${stacks-dir}:${stacks-dir}:rw"
      "/root/dockge:/app/data:rw"
      "/var/run/docker.sock:/var/run/docker.sock:rw"
    ];
    ports = [
      "127.0.0.1:5001:5001/tcp"
    ];
    log-driver = "journald";
  };
  
  systemd.services."docker-dockge" = {
      serviceConfig = {
        Restart = lib.mkOverride 500 "always";
        RestartMaxDelaySec = lib.mkOverride 500 "1m";
        RestartSec = lib.mkOverride 500 "100ms";
        RestartSteps = lib.mkOverride 500 9;
      };
      wantedBy = [
        "multi-user.target"
        "network.target"
        "docker.service"
      ];
    };
}
