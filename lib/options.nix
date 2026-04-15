let
  d = dest: { inherit dest; auth = false; };
  da = dest: { inherit dest; auth = true; };
  
  ext4 = path: { inherit path; type = "ext4"; };
  btrfs = path: { inherit path; type = "btrfs"; };
in {
  flake-path = "~/Projects/nix-flake"; # set this to the cloned repo path

  username = "satr14";
  timezone = "Asia/Jakarta";
  locale = "en_US.UTF-8";
  zsh-theme = "refined"; # good themes: refined, re5et, risto, amuse, afowler, pmcgee, itchy, example, strug, pygmalion, muse

  legacy-boot = false; # enables grub if true
  enable-dm = true; # enable display manager (for server use)

  wol = "enp0s31f6"; # set to iface name to enable Wake-on-LAN
  swapfile = 8 * 1024; # swapfile size in MB, set to 0 to disable (only used for server, desktop will use swap partition instead)
  resume-dev = "/dev/disk/by-uuid/1721721a-bb5a-4166-a077-9500d30be2ac"; # set to swap partition to enable hibernation
  
  homelab = rec {
    domain = "satr14.my.id"; # root domain for dns, ssl certs, reverse proxy, etc.
    cf-tunnel-id = "26318288-cdd7-4e58-904b-c45f10d3e40a";
    ssh-keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIESvQFXoUBafatqnxTd6qk3WEOcfwb3AIWVTstR3lHzX forgejo"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJtdH1YqRH9xhuHMivezLvj/hpH77yfH3HUCaRboB/hb forgejo-deploy-runner"
    ];
    disks = {
      # gallery = ext4 "/dev/disk/by-uuid/834f51c1-90ee-4601-ba76-ef0419198d67"; # disk for photo gallery 
      # data = ext4 "/dev/disk/by-uuid/a5752dd6-092d-484c-969c-2fdc7cb4a5f0"; # disk for app data
      # host = ext4 "/dev/disk/by-uuid/968f14a4-631e-4325-8cd1-f9aec0da9e4d"; # disk for media collection (named host for backwards compatibility)
      # ^^ virtual disks
      
      # achive = ext4 "/dev/disk/by-uuid/"; # long term archival 
      data = ext4 "/dev/disk/by-uuid/aa453135-4b7a-4b12-8efc-f3dda093d2b7"; # app data
      share = btrfs "/dev/disk/by-uuid/f1ee1d17-e852-4e02-ae86-eaf6116a2aeb"; # file server
    };
    dash = [
      [ "PocketID" "authentik" "https://auth.${domain}" "http://localhost:1411/" ]
      [ "Forgejo" "forgejo" "https://git.${domain}" "http://localhost:5080/" ]
      [ "Copyparty" "files" "https://cdn.${domain}" "http://localhost:3923/" ]
      [ "CryptPad" "cryptpad" "https://docs.${domain}" "http://localhost:7090/" ]
      [ "CodeServer" "coder" "https://code.proxy.${domain}" "http://localhost:8443/" ]
      [ "AdGuardHome" "adguard" "https://dns.proxy.${domain}" "http://localhost:8088/" ]
      [ "Traefik" "traefikproxy" "https://dynamic.proxy.${domain}/dashboard/" "" ]
      [ "Immich" "immich" "https://gallery.proxy.${domain}" "http://localhost:2283/" ]
      [ "Jellyfin" "jellyfin" "https://media.proxy.${domain}" "http://localhost:8096/" ]
      [ "VaultWarden" "vaultwarden" "https://pass.proxy.${domain}" "http://localhost:8060/" ]
      [ "Ollama" "ollama" "https://ai.proxy.${domain}" "http://localhost:8080/" ]
      [ "Ntfy" "ntfy" "https://notify.proxy.${domain}" "http://localhost:8067/" ]
      [ "SearXNG" "searxng" "https://search.proxy.${domain}" "http://localhost:8091/" ]
      [ "Dockge" "docker" "https://containers.proxy.${domain}" "http://localhost:5001/" ]
    ];
    routes = {
      "git.${domain}"     = "http://localhost:5080";
      "cdn.${domain}"     = "http://localhost:3923";
      "docs.${domain}"    = "http://localhost:7090";
      "auth.${domain}"    = "http://localhost:1411";
      "dash.${domain}"    = "http://localhost:5070";
      "media.${domain}"   = "http://localhost:8096";
      "gallery.${domain}" = "http://localhost:2284";
    };
    proxy = {
      base = "proxy.${domain}";
      hosts = {
        "server"     = d "https://server.dns.${domain}:8006";
        "router"     = d "http://router.dns.${domain}:80";
        "home"       = d "http://home.dns.${domain}:8123";
        
        "containers" = da "http://localhost:5001";
        "code"       = da "http://localhost:8443";
        "dns"        = da "http://localhost:8088";
        
        "gallery"    = d "http://localhost:2283";
        "dynamic"    = d "http://localhost:8082";
        "search"     = d "http://localhost:8091";
        "notify"     = d "http://localhost:8067";
        "media"      = d "http://localhost:8096";
        "pass"       = d "http://localhost:8060";
        "auth"       = d "http://localhost:1411";
        "git"        = d "http://localhost:5080";
        "cdn"        = d "http://localhost:3923";
        "ai"         = d "http://localhost:8080";
        "@"          = d "http://localhost:5070";
      };
      redirects = {
        "www"  = "https://${proxy.base}";
        "dash" = "https://${proxy.base}";
        "immich" = "https://gallery.${proxy.base}";
        "2fa" = "https://2fa.${domain}";
      };
    };
    records = [
      [ "server.dns.${domain}"     "10.3.14.69"         ]
      [ "router.dns.${domain}"     "10.3.14.1"          ]
      [ "home.dns.${domain}"       "10.3.14.235"        ]
      [ "games.dns.${domain}"      "10.3.14.37"         ]
      [ "workspace.dns.${domain}"  "10.3.14.57"         ]
      [ "old-main.dns.${domain}"   "10.3.14.42"         ] # old main machine for connecting while migrating
      
      [ "main.dns.${domain}"       "10.3.14.215"        ] # this machine
      [ "proxy.${domain}"          "main.dns.${domain}" ]
      [ "*.proxy.${domain}"        "proxy.${domain}"    ]
      
      # [ "lancache.steamcontent.com" "main.dns.${domain}" ]
      # [ "steam.cache.lancache.net" "main.dns.${domain}" ]
    ];
  };

  rice = {
    font = "monospace"; # global font for rice GUIs, leave empty to use monospace
    bar = {
      top = true; # false will put the bar at the bottom
      fragmented = true; # enable fragmented bar, false will make it a single block
      minimal = false; # less verbose bar
    };
    gap = { # set the gap size in pixel
      outer = 8;
      inner = 4;
    };
    borders = {
      colored = false; # enable colored borders
      rounded = 0; # rounded corners in pixel
      size = 1; # border size in pixel
    };
  };

  ctp-opt = { # configure Catppuccin theme
    primary = "sky";
    accent = "sapphire";
    flavor = "mocha";
  };

  git = { # setup your git author
    username = "satr14"; # forgejo username
    server = "https://git.satr14.my.id"; # forgejo server url
    user = "satr14";
    email = "admin@satr14.my.id";
  };
}
