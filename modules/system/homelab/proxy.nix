{ pkgs, homelab, lib, ... }: let
  htpasswd = "/mnt/data/apps/nginx/htpasswd";
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
    certs."${homelab.proxy.base}" = {
      domain = "*.${homelab.proxy.base}";
      extraDomainNames = [ homelab.proxy.base ];
      dnsProvider = "cloudflare";
      environmentFile = "/mnt/data/apps/acme/cf-api.env";
      # ^^^contents: CLOUDFLARE_DNS_API_TOKEN=XXXXX
    };
  };
  
  services = {
    nginx = {
      enable = true;
      package = pkgs.angie;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      virtualHosts = {
        "_" = {
          default = true;
          forceSSL = true;
          useACMEHost = homelab.proxy.base;
          # locations."/".return = "404";
          locations."/" = {
            proxyPass = "http://127.0.0.1:81"; # traefik for docker container dynamic proxy
            proxyWebsockets = true;
            extraConfig = exta-conf;
          };
        };
      } // lib.mapAttrs' (subdomain: cfg: lib.nameValuePair "${subdomain}.${homelab.proxy.base}" {
        useACMEHost = homelab.proxy.base;
        forceSSL = true;
        locations."/".return = "301 ${cfg}";
      }) homelab.proxy.redirects // lib.mapAttrs' (subdomain: cfg: lib.nameValuePair (if subdomain == "@" then homelab.proxy.base else "${subdomain}.${homelab.proxy.base}") {
        useACMEHost = homelab.proxy.base;
        forceSSL = true;
        extraConfig = ''
          access_log /var/log/nginx/${subdomain}.access.log;
          error_log /var/log/nginx/${subdomain}.error.log;
        '';
        locations."/" = {
          proxyPass = cfg.dest;
          proxyWebsockets = true;
          basicAuthFile = if cfg.auth then htpasswd else null;
          extraConfig = exta-conf;
        };
      }) homelab.proxy.hosts;
    };
    traefik = {
      enable = true;
      dynamicConfigOptions = {
        http.middlewares.auth.basicAuth.usersFile = htpasswd;
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
