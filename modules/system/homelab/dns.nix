{ homelab, ... }: {
  services.adguardhome = {
    enable = true;
    host = "0.0.0.0";
    port = 8088;
    settings = {
      dns = {
        upstream_dns = [ "https://security.cloudflare-dns.com/dns-query" ];
        bootstrap_dns = [ "1.1.1.2" "1.0.0.2" ];
      };
      querylog = {
        interval = "2160h";
        enabled = true;
      };
      filtering = {
        blocking_mode = "null_ip";
        protection_enabled = true;
        safebrowsing_enabled = true;
        parental_enabled = true;
        rewrites_enabled = true;
        filtering_enabled = true;
        safe_search = {
          enabled = true;
          youtube = true;
          google = true;
          bing = true;
          duckduckgo = true;
        };
        rewrites = map (e: { enabled = true; domain = builtins.elemAt e 0; answer = builtins.elemAt e 1; }) [
          [ "router.dns.${homelab.domain}"     "10.3.14.1"                  ]
          [ "main.dns.${homelab.domain}"       "10.3.14.42"                 ]
          [ "websites.dns.${homelab.domain}"   "10.3.14.36"                 ]
          [ "games.dns.${homelab.domain}"      "10.3.14.37"                 ]
          [ "media.dns.${homelab.domain}"      "10.3.14.55"                 ]
          [ "workspace.dns.${homelab.domain}"  "10.3.14.57"                 ]
          [ "server.dns.${homelab.domain}"     "10.3.14.69"                 ]
          [ "home.dns.${homelab.domain}"       "10.3.14.235"                ]
          [ "nas.dns.${homelab.domain}"        "10.3.14.217"                ]
          [ "proxy.${homelab.domain}"          "10.3.14.120"                ]
          [ "*.proxy.${homelab.domain}"        "proxy.${homelab.domain}"    ]
          [ "lancache.steamcontent.com"        "main.dns.${homelab.domain}" ]
          [ "steam.cache.lancache.net"         "main.dns.${homelab.domain}" ]
        ];
      };
      filters = map (url: { enabled = true; url = url; }) [
        "https://adaway.org/hosts.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_10.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_42.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_31.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_59.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_30.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_50.txt"
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_12.txt"
        "https://raw.githubusercontent.com/PolishFiltersTeam/KADhosts/master/KADhosts.txt"
        "https://raw.githubusercontent.com/anudeepND/blacklist/master/adservers.txt"
        "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
        "https://v.firebog.net/hosts/static/w3kbl.txt"
        "https://v.firebog.net/hosts/Prigent-Ads.txt"
        "https://v.firebog.net/hosts/Admiral.txt"
        "https://someonewhocares.org/hosts/hosts"
      ];
      whitelist_filters = map (url: { enabled = true; url = url; }) [
        "https://gist.githubusercontent.com/mul14/eb05e88fcec5bb195cbb/raw/75a1fe122a4502e8d5a5268c9d0ec28332b19d5d/hosts"
      ];
    };
  };
}