{ homelab, ... }: {
  services.cloudflared = {
    enable = true;
    tunnels.homelab = {
      credentialsFile = "/mnt/data/cloudflared/homelab.json";
      certificateFile = "/mnt/data/cloudflared/cert.pem";
      default = "http_status:404";
      ingress = {
        "git.${homelab.domain}"     = "http://localhost:3000";
        "auth.${homelab.domain}"    = "http://localhost:1411";
        "dash.${homelab.domain}"    = "http://localhost:5070";
        "gallery.${homelab.domain}" = "http://localhost:2284";
      };
    };
  };
}