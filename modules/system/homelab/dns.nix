{ homelab, ... }: let
  blacklist = [
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
  whitelist = [
    "https://gist.githubusercontent.com/mul14/eb05e88fcec5bb195cbb/raw/75a1fe122a4502e8d5a5268c9d0ec28332b19d5d/hosts"
  ];
in {
  services.adguardhome = {
    enable = true;
    host = "127.0.0.1";
    port = 8088;
    mutableSettings = false;
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
          youtube = false;
        };
        rewrites = map (e: {
          enabled = true;
          domain = builtins.elemAt e 0;
          answer = builtins.elemAt e 1;
        }) homelab.records;
      };
      filters = map (url: { enabled = true; url = url; }) blacklist;
      whitelist_filters = map (url: { enabled = true; url = url; }) whitelist;
    };
  };
}