{ homelab, lib, ... }: let
  base = "proxy.${homelab.domain}";
  hosts = {
    "server"     = { dest = "https://server.dns.${homelab.domain}:8006"; auth = false; };
    "router"     = { dest = "http://router.dns.${homelab.domain}:80"; auth = false; };
    "home"       = { dest = "http://home.dns.${homelab.domain}:8123"; auth = false; };
    
    "containers" = { dest = "http://localhost:5001"; auth = true; };
    "dynamic"    = { dest = "http://localhost:8082"; auth = true; };
    "dns"        = { dest = "http://localhost:8088"; auth = true; };
    
    "gallery"    = { dest = "http://localhost:2283"; auth = false; };
    "remote"     = { dest = "http://localhost:8085"; auth = false; };
    "search"     = { dest = "http://localhost:8091"; auth = false; };
    "notify"     = { dest = "http://localhost:8067"; auth = false; };
    "media"      = { dest = "http://localhost:8096"; auth = false; };
    "pass"       = { dest = "http://localhost:8060"; auth = false; };
    "auth"       = { dest = "http://localhost:1411"; auth = false; };
    "git"        = { dest = "http://localhost:5080"; auth = false; };
    "ai"         = { dest = "http://localhost:8080"; auth = false; };
    "@"          = { dest = "http://localhost:5070"; auth = false; };
  };
  redirects = {
    "www"  = "https://proxy.${homelab.domain}";
    "dash" = "https://proxy.${homelab.domain}";
    "immich" = "https://gallery.proxy.${homelab.domain}";
    "2fa" = "https://2fa.${homelab.domain}"
  };
  exta-conf = ''
    # proxy_set_header X-Auth-User $remote_user;
    proxy_read_timeout 600s;
    proxy_send_timeout 600s;
    proxy_buffering off;
    proxy_cache off;
    send_timeout 600s;
    client_max_body_size 50000M;
  '';
in {
  users.users = {
    nginx.extraGroups = [ "acme" ];
    traefik.extraGroups = [ "docker" ];
  };
  
  security.acme = {
    acceptTerms = true;
    defaults.email = "admin@${homelab.domain}";
    certs."${base}" = {
      domain = "*.${base}";
      extraDomainNames = [ base ];
      dnsProvider = "cloudflare";
      environmentFile = "/mnt/data/acme/.env";
      # ^^^contents: CLOUDFLARE_DNS_API_TOKEN=XXXXX
    };
  };
  
  services = {
    nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      virtualHosts = {
        "_" = {
          default = true;
          forceSSL = true;
          useACMEHost = base;
          # locations."/".return = "404";
          locations."/" = {
            proxyPass = "http://127.0.0.1:81"; # traefik for docker container dynamic proxy
            proxyWebsockets = true;
            extraConfig = exta-conf;
          };
        };
      } // lib.mapAttrs' (subdomain: cfg: lib.nameValuePair "${subdomain}.${base}" {
        useACMEHost = base;
        forceSSL = true;
        locations."/".return = "301 ${cfg}";
      }) redirects // lib.mapAttrs' (subdomain: cfg: lib.nameValuePair (if subdomain == "@" then base else "${subdomain}.${base}") {
        useACMEHost = base;
        forceSSL = true;
        extraConfig = ''
          access_log /var/log/nginx/${subdomain}.access.log;
          error_log /var/log/nginx/${subdomain}.error.log;
        '';
        locations."/" = {
          proxyPass = cfg.dest;
          proxyWebsockets = true;
          basicAuthFile = if cfg.auth then "/var/lib/nginx/.htpasswd" else null;
          extraConfig = exta-conf;
        };
      }) hosts;
    };
    traefik = {
      enable = true;
      staticConfigOptions = {
        entryPoints = {
          traefik.address = "127.0.0.1:8082";
          web = {
            address = "127.0.0.1:81";
            forwardedHeaders.trustedIPs = [ "127.0.0.1/32" ];
          };
        };
        api = {
          dashboard = true;
          insecure = true;
        };
        global = {
          checkNewVersion = false;
          sendAnonymousUsage = false;
        };
        providers.docker = {
          endpoint = "unix:///var/run/docker.sock";
          exposedByDefault = false; 
        };
      };
    };
  };
}