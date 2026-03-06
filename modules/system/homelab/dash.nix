{ timezone, homelab, ... }: let 
  rss = [
    "https://www.raspberrypi.com/news/feed/"
    "https://www.jeffgeerling.com/blog.xml"
    "https://www.howtogeek.com/feed/"
    "https://hackaday.com/feed/rss"
    "https://www.xda-developers.com/feed/"
    "https://9to5mac.com/feed/"
    "https://9to5google.com/feed/"
    "https://www.cnx-software.com/feed/"
    "https://selfh.st/rss/"
    "https://www.joshwcomeau.com/rss.xml"
    "https://samwho.dev/rss.xml"
    "https://ishadeed.com/feed.xml"
  ];
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
  ];
  gh = [
    "tailscale/tailscale"
    "glanceapp/glance"
    "nixos/nixpkgs"
    "ollama/ollama"
    "nginx/nginx"
    "oven-sh/bun"
  ];
  search = [
    [ "Website" "!!" "https://{QUERY}" ]
    [ "CVE" "!cve" "https://securityvulnerability.io/vulnerability/CVE-{QUERY}" ]
    [ "YouTube" "!yt" "https://www.youtube.com/results?search_query={QUERY}" ]
    [ "GitHub" "!gh" "https://github.com/search?q={QUERY}" ]
    [ "Nix Packages" "!nix" "https://search.nixos.org/packages?channel=unstable&type=packages&query={QUERY}" ]
    [ "Nix Options" "!opt" "https://mynixos.com/search?q={QUERY}" ]
    [ "Flight Radar 24" "!f" "https://www.flightradar24.com/data/flights/{QUERY}" ]
    [ "Google Web Results Only" "!s" "https://google.com/search?udm=14&q={QUERY}" ]
  ];
  monitor = [
    [ "Hypervisor" "https://10.3.14.69:8006/" ]
    [ "Router" "http://10.3.14.1:80/" ]
    [ "DNS" "http://localhost:8088/" ]
    [ "CDN" "http://localhost:3000/" ]
    [ "Proxy" "https://proxy.${homelab.domain}/" ]
  ];
  services = [
    [ "PocketID" "authentik" "https://auth.${homelab.domain}" "http://localhost:1411/" ]
    [ "Forgejo" "forgejo" "https://git.${homelab.domain}" "http://localhost:5080/" ]
    [ "AdGuardHome" "adguard" "https://dns.proxy.${homelab.domain}" "http://localhost:8088/" ]
    [ "ApacheHTTPD" "apache" "https://cdn.proxy.${homelab.domain}" "http://localhost:3000/" ]
    [ "Immich" "immich" "https://gallery.proxy.${homelab.domain}" "http://localhost:2283/" ]
    [ "VaultWarden" "vaultwarden" "https://pass.proxy.${homelab.domain}" "http://localhost:8060/" ]
    [ "Ollama" "ollama" "https://ai.proxy.${homelab.domain}" "http://localhost:8080/" ]
    [ "Dockge" "docker" "https://containers.proxy.${homelab.domain}" "http://localhost:5001/" ]
    [ "Guacamole" "apacheguacamole" "https://remote.proxy.${homelab.domain}" "http://localhost:8085/guacamole/" ]
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
    environmentFile = "/var/lib/glance/.env";
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
                {
                  type = "rss";
                  hide-header = true;
                  title = "rss";
                  limit = 12;
                  cache = "12h";
                  feeds = map (e: { url = e; }) rss;
                }
              ];
            }
            {
              size = "full";
              widgets = [
                {
                  type = "search";
                  hide-header = true;
                  autofocus = true;
                  search-engine = "google";
                  bangs = map (e: {
                    title = builtins.elemAt e 0;
                    shortcut = builtins.elemAt e 1;
                    url = builtins.elemAt e 2;
                  }) search;
                }
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
                  type = "to-do";
                  id = "tasks";
                  hide-header = true;
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
                  type = "releases";
                  cache = "1d";
                  hide-header = true;
                  repositories = gh;
                }
              ];
            }
          ];
        }
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
                  servers = [{ type = "local"; }];
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
                  }) services;
                }
                {
                  type = "docker-containers";
                  title = "Containers";
                  format-container-names = true;
                }
              ];
            }
          ];
        }
      ];
    };
  };
}
