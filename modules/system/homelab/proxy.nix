{ homelab, lib, ... }: let
  d = dest: { inherit dest; auth = false; };
  da = dest: { inherit dest; auth = true; };

  base = "proxy.${homelab.domain}";
  hosts = {
    "server"     = d "https://server.dns.${homelab.domain}:8006";
    "router"     = d "http://router.dns.${homelab.domain}:80";
    "home"       = d "http://home.dns.${homelab.domain}:8123";
    
    "containers" = da "http://localhost:5001";
    "dns"        = da "http://localhost:8088";
    
    "gallery"    = d "http://localhost:2283";
    "dynamic"    = d "http://localhost:8082";
    "remote"     = d "http://localhost:8085";
    "search"     = d "http://localhost:8091";
    "notify"     = d "http://localhost:8067";
    "media"      = d "http://localhost:8096";
    "pass"       = d "http://localhost:8060";
    "auth"       = d "http://localhost:1411";
    "git"        = d "http://localhost:5080";
    "ai"         = d "http://localhost:8080";
    "@"          = d "http://localhost:5070";
  };
  redirects = {
    "www"  = "https://proxy.${homelab.domain}";
    "dash" = "https://proxy.${homelab.domain}";
    "immich" = "https://gallery.proxy.${homelab.domain}";
    "2fa" = "https://2fa.${homelab.domain}";
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
      dynamicConfigOptions = {
        http.middlewares.auth.basicAuth.usersFile = "/var/lib/nginx/.htpasswd";
      };
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