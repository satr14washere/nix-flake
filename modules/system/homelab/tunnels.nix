{ pkgs, lib, homelab, ... }: let
  routes = {
    "git.${homelab.domain}"     = "http://localhost:3000";
    "auth.${homelab.domain}"    = "http://localhost:1411";
    "dash.${homelab.domain}"    = "http://localhost:5070";
    "media.${homelab.domain}"   = "http://localhost:8096";
    "gallery.${homelab.domain}" = "http://localhost:2284";
  };
in {
  services.cloudflared = {
    enable = true;
    tunnels.homelab = {
      credentialsFile = "/mnt/data/cloudflared/homelab.json";
      certificateFile = "/mnt/data/cloudflared/cert.pem";
      default = "http_status:404";
      ingress = routes;
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
      ${pkgs.cloudflared}/bin/cloudflared tunnel --origincert /mnt/data/cloudflared/cert.pem route dns ${homelab.cf-tunnel-id} ${domain} || true
    '') builtins.attrNames routes;
  };
}