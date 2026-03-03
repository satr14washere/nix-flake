{ homelab, lib, ... }: let
  base = "proxy.${homelab.domain}";
  proxy-mappings = {
    "dns"        = { dest = "http://localhost:8088"; auth = true; };
    "ai"         = { dest = "http://localhost:8080"; auth = true; };
    
    # "jsr"        = { dest = "http://localhost:5055"; auth = false; };
    # "rdr"        = { dest = "http://localhost:5055"; auth = false; };
    # "snr"        = { dest = "http://localhost:5055"; auth = false; };
    # "qbt"        = { dest = "http://localhost:8020"; auth = false; };
    # "jkt"        = { dest = "http://localhost:9117"; auth = false; };
    # "media"      = { dest = "http://localhost:8096"; auth = false; };
    
    "containers" = { dest = "http://localhost:5001"; auth = false; };
    "gallery"    = { dest = "http://localhost:2283"; auth = false; };
    "remote"     = { dest = "http://localhost:8085"; auth = false; };
    "auth"       = { dest = "http://localhost:1411"; auth = false; };
    "cdn"        = { dest = "http://localhost:3000"; auth = false; };
    "git"        = { dest = "http://localhost:5080"; auth = false; };
    "@"          = { dest = "http://localhost:5070"; auth = false; };
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
      virtualHosts = {
        "_" = {
          default = true;
          forceSSL = true;
          useACMEHost = base;
          locations."/".return = "404";
        };
      } // lib.mapAttrs' (subdomain: cfg: lib.nameValuePair (if subdomain == "@" then base else "${subdomain}.${base}") {
        useACMEHost = base;
        forceSSL = true;
        
        locations."/" = {
          proxyPass = cfg.dest;
          proxyWebsockets = true;
          basicAuthFile = if cfg.auth then "/var/lib/nginx/.htpasswd" else null;
          extraConfig = ''
            proxy_set_header X-Auth-User $remote_user;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            client_max_body_size 50000M;
            proxy_read_timeout   600s;
            proxy_send_timeout   600s;
            send_timeout         600s;
          '';
        };
      }) proxy-mappings;
    };
}