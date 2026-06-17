{ timezone, homelab, ... }:$ let 
  yt = [
    "UCXuqSBlHAE6Xw-yeJA0Tunw" # LinusTechTips
    "UCsBjURrPoezykLs9EqgamOA" # Fireship
    "UC2Xd-TjJByJyK2w1zNwY0zQ" # BeyondFireship
    "UC6biysICWOJ-C3P4Tyeggzg" # LowLevel
    "UCR-DXc1voovS8nhAvccRZhg" # JeffGeerling
    "UCzgA9CBrIXPtkB2yNTTiy1w" # Level2Jeff
    "UCgdTVe88YVSrOZ9qKumhULQ" # HardwareHaven
    "UCOk-gHyjcWZNj3Br4oxwh0A" # TechnoTim
    "UCZNhwA1B5YqiY1nLzmM0ZRg" # ChristianLempa
    "UC9evhW4JB_UdXSLeZGy8lGw" # RaidOwl
    "UCHnyfMqiRRG1u-2MsSQLbXA" # Veritasium
    "UCYO_jab_esuFRV4b17AJtAw" # 3Blue1Brown
    "UChIs72whgZI9w6d6FhwGGHA" # GamersNexus
    "UCY1kMZp36IQSyNx_9h4mpCg" # MarkRober
    "UC8ENHE5xdFSwx71u3fDH5Xw" # ThePrimeagen
    "UCUyeluBRhGPCW4rPe_UvBZQ" # ThePrimeTime
    "UCv6J_jJa8GJqFwQNgNrMuww" # ServeTheHome
    "UCGKEMK3s-ZPbjVOIuAV8clQ" # CoreDumped
    "UCWQaM7SpSECp9FELz-cHzuQ" # DreamsOfCode
  ];
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
                {
                  type = "to-do";
                  id = "tasks";
                }
              ];
            }
            {
              size = "full";
              widgets = [
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
          ];
        }
        {
          name = "Home";
          show-mobile-header = true;
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
              ];
            }
            {
              size = "full";
              widgets = [
                {
                  type = "hacker-news";
                  hide-header = true;
                  limit = 5;
                  cache = "1h";
                }
                {
                  type = "videos";
                  hide-header = true;
                  style = "grid-cards";
                  limit = 18;
                  channels = yt;
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
              ];
            }
          ];
        }
      ];
    };
  };
}
