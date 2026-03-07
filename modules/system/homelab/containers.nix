{ homelab, lib, ... }: let
  stacks-dir = "/mnt/data/dockge/stacks";
in {
  virtualisation.oci-containers.containers."dockge" = {
    image = "louislam/dockge:nightly";
    environment = {
      "DOCKGE_STACKS_DIR" = stacks-dir;
    };
    volumes = [
      "${stacks-dir}:${stacks-dir}:rw"
      "/mnt/data/dockge/data:/app/data:rw"
      "/var/run/docker.sock:/var/run/docker.sock:rw"
    ];
    ports = [
      "127.0.0.1:5001:5001/tcp"
    ];
    log-driver = "journald";
    labels = {
      "glance.name" = "Dockge";
      "glance.icon" = "si:docker";
      "glance.url" = "http://containers.proxy.${homelab.domain}:5001/";
      "glance.description" = "Docker Compose Management UI";
      "glance.hide" = "true";
    };
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
