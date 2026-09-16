{ timezone, homelab, ... }: let 
  monitor = [
    [ "DNS" "http://localhost:8088/" ]
    [ "Proxy" "https://proxy.${homelab.domain}/" ]
  ];
  bookmarks = [
    [ "Tailscale" "tailscale" "https://login.tailscale.com/" ]
    [ "Cloudflare" "cloudflare" "https://dash.cloudflare.com/" ]
    [ "ZeroTrust" "1dot1dot1dot1" "https://one.dash.cloudflare.com/" ]
    [ "PlayIt" "ngrok" "https://playit.gg/account/tunnels" ]
    [ "ZeroTier" "zerotier" "https://my.zerotier.com" ]
  ];
in {
  users = {
    groups.glance = {};
    users.glance = {
      extraGroups = [ "docker" ];
      isSystemUser = true;
      group = "glance";
    };
  };
  services.glance = {
    enable = true;
    settings = {
      server = {
        host = "127.0.0.1";
        port = 5070;
      };

      theme = {
        background-color = "240 21 15";
        contrast-multiplier = 1.2;
        primary-color = "217 92 83";
        positive-color = "115 54 76";
        negative-color = "347 70 65";
      };

      pages = [
        {
          name = "Dashboard";
          show-mobile-header = true;
          width = "slim";
          columns = [
            {
              size = "small";
              widgets = [
                {
                  type = "clock";
                  hide-header = true;
                  hour-format = "12h";
                  timezone = timezone;
                }
                {
                  type = "calendar";
                  hide-header = true;
                  first-day-of-week = "monday";
                }
                {
                  type = "monitor";
                  title = "Critical Systems";
                  cache = "15s";
                  style = "compact";
                  show-failing-only = true;
                  sites = map (e: {
                    same-tab = true;
                    allow-insecure = true;
                    title = builtins.elemAt e 0;
                    url = builtins.elemAt e 1;
                  }) monitor;
                }
                {
                  type = "dns-stats";
                  title = "DNS Stats";
                  service = "adguard";
                  url = "http://localhost:8088/";
                  hour-format = "12h";
                }
                {
                  type = "bookmarks";
                  groups = [
                    {
                      links = [{
                        same-tab = true;
                        title = "NixFlake";
                        icon = "si:nixos";
                        url = "https://flake.satr14.my.id";
                      }];
                    }
                    {
                      links = map (e: {
                        same-tab = true;
                        title = builtins.elemAt e 0;
                        icon = "si:${builtins.elemAt e 1}";
                        url = builtins.elemAt e 2;
                        alt-status-codes = [ 401 ];
                      }) bookmarks;
                    }
                  ];
                }
              ];
            }
            {
              size = "full";
              widgets = [
                {
                  type = "to-do";
                  id = "tasks";
                }
                {
                  type = "server-stats";
                  servers = [{
                    type = "local";
                    mountpoints = {
                      "/boot".hide = true;
                      "/nix/store".hide = true;
                      "/var/lib/vaultwarden".hide = true;
                      "/var/lib/private/cryptpad".hide = true;
                      "/var/lib/acme/proxy.satr14.my.id".hide = true;
                    };
                  }];
                }
                {
                  type = "monitor";
                  cache = "1m";
                  title = "Services";
                  sites = map (e: { 
                    same-tab = true;
                    allow-insecure = true;
                    title = builtins.elemAt e 0;
                    icon = "si:${builtins.elemAt e 1}";
                    url = builtins.elemAt e 2;
                    check-url = builtins.elemAt e 3;
                  }) homelab.dash;
                }
                {
                  type = "docker-containers";
                  title = "Containers";
                  format-container-names = true;
                  hide-by-default = true;
                }
              ];
            }
            {
              size = "small";
              widgets = [
                {
                  type = "weather";
                  hide-header = true;
                  location = "Jakarta, Indonesia";
                  units = "metric";
                  hour-format = "12h";
                }
                {
                  type = "repository";
                  repository = "is-a-dev/register";
                  pull-requests-limit = 5;
                  issues-limit = 3;
                  commits-limit = 0;
                  hide-header = true;
                }
                {
                  type = "repository";
                  repository = "partofmyid/register";
                  pull-requests-limit = 5;
                  issues-limit = 3;
                  commits-limit = 0;
                  hide-header = true;
                }
                {
                  type = "hacker-news";
                  hide-header = true;
                  limit = 5;
                  cache = "1h";
                }
              ];
            }
          ];
        }
      ];
    };
  };
}
