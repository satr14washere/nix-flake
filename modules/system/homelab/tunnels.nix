{ pkgs, lib, homelab, ... }: {
  services.cloudflared = {
    enable = true;
    tunnels.homelab = {
      credentialsFile = "/mnt/data/apps/cloudflared/homelab.json";
      certificateFile = "/mnt/data/apps/cloudflared/cert.pem";
      default = "http_status:404";
      ingress = homelab.routes;
    };
  };
  
  systemd.services.cloudflared-dns-route = {
    description = "Sync Cloudflare Tunnel DNS routes";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    
    serviceConfig = {
      RemainAfterExit = true;
      Type = "oneshot";
      User = "root";
    };

    script = lib.concatMapStringsSep "\n" (domain: ''
      echo "Ensuring DNS route for ${domain}..."
      ${pkgs.cloudflared}/bin/cloudflared tunnel --origincert /mnt/data/apps/cloudflared/cert.pem route dns --overwrite-dns $(cat /mnt/data/apps/cloudflared/homelab.json | jq -r .TunnelID) ${domain} || true
    '') (builtins.attrNames homelab.routes);
  };
}
