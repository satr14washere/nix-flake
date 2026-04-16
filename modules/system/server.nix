{ lib, homelab, ... }: let
  ts-flags = [
    "--advertise-exit-node"
    "--advertise-routes=10.3.14.0/24,192.168.1.0/24"
    "--ssh" "--webclient"
  ];
in {
  imports = [
    # ./homelab/share.nix # gonna use omv for now
    
    ./homelab/containers.nix
    ./homelab/gallery.nix
    ./homelab/tunnels.nix
    ./homelab/notify.nix
    ./homelab/search.nix
    ./homelab/media.nix
    ./homelab/proxy.nix
    ./homelab/auth.nix
    ./homelab/pass.nix
    ./homelab/dash.nix
    ./homelab/code.nix
    ./homelab/dns.nix
    ./homelab/git.nix
    ./homelab/ai.nix
    ./homelab/db.nix
    
    ./core/swapfile.nix
    ./core/oom.nix
    ./misc/theme.nix
    ./base.nix
  ];

  users.users.root.openssh.authorizedKeys.keys = homelab.ssh-keys;
  
  services.tailscale = {
    enable = true;
    authKeyFile = "/mnt/data/apps/tailscale/authkey";
    useRoutingFeatures = "server";
    extraUpFlags = ts-flags;
    extraSetFlags = ts-flags;
  };
  
  virtualisation = {
    oci-containers.backend = "docker";
    docker = {
      enable = true;
      autoPrune.enable = true;
      enableOnBoot = true;
    };
  };

  networking = {
    networkmanager.dns = "none";
    nameservers = lib.mkForce [ "127.0.0.1" ];
    extraHosts = let
      isIP = s: builtins.match "[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+" s != null;
      ipRecords = builtins.filter (r: isIP (builtins.elemAt r 1)) homelab.records;
    in builtins.concatStringsSep "\n" (map (r: "${builtins.elemAt r 1} ${builtins.elemAt r 0}") ipRecords);
  };

  systemd.services.nginx = {
    after = [ "adguardhome.service" ];
    wants = [ "adguardhome.service" ];
  };
}
