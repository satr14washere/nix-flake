{ homelab, ... }: let
  base = "proxy.${homelab.domain}";
  proxyMappings = {
    "dns" = { dest = "http://localhost:8088"; auth = true; };
    "cdn" = { dest = "http://localhost:3000"; auth = false; };
  };
in {
  users.users.nginx.extraGroups = [ "acme" ];
  security.acme = {
    acceptTerms = true;
    defaults.email = "admin@${homelab.domain}";
    certs."${base}" = {
      domain = "*.${base}";
      extraDomainNames = [ base ];
      dnsProvider = "cloudflare";
      environmentFile = "/var/lib/acme/cloudflare.env";
      # ^^^contents: CLOUDFLARE_DNS_API_TOKEN=XXXXX
    };
  };
  
  services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts = builtins.mapAttrs (subdomain: cfg: {
        hostName = "${subdomain}.${base}";
        useACMEHost = base;
        forceSSL = true;
        
        locations."/" = {
          proxyPass = cfg.dest;
          proxyWebsockets = true;
          basicAuthFile = if cfg.auth then "/var/lib/nginx/.htpasswd" else null;
          extraConfig = ''
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
      }) proxyMappings;
    };
}