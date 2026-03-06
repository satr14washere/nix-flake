{
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
    disks = {
      share = "/dev/disk/by-uuid/ac61f6c8-ac20-41dd-ba93-41c4a225dc98"; # disk for nas share
      data = "/dev/disk/by-uuid/a5752dd6-092d-484c-969c-2fdc7cb4a5f0"; # disk for app data
    };
    records = [
      [ "router.dns.${domain}"     "10.3.14.1"                  ]
      [ "workspace.dns.${domain}"  "10.3.14.57"                 ]
      [ "server.dns.${domain}"     "10.3.14.69"                 ]
      [ "home.dns.${domain}"       "10.3.14.235"                ]
      
      [ "main.dns.${domain}"       "10.3.14.215"                ] # this machine
      [ "old-main.dns.${domain}"   "10.3.14.42"                 ] # old main machine for connecting while migrating
      [ "proxy.${domain}"          "main.dns.${domain}" ]
      [ "*.proxy.${domain}"        "proxy.${domain}"    ]
      
      # [ "lancache.steamcontent.com"        "main.dns.${domain}" ]
      # [ "steam.cache.lancache.net"         "main.dns.${domain}" ]
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
    user = "Satria";
    email = "admin@satr14.my.id";
  };
}
