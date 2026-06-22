{ inputs, lib, pkgs, ... }: let
  name = "mc0-vanilla-plus";
  production = true;
  ram-allocation-mb = 12288;
  rcon-pass = "howdy";
  modpack = let
    commit = "e47a428b61fc087f4c733258e5a282c21b32d9c3";
    path = if production then "commit/${commit}" else "branch/main";
  in pkgs.fetchPackwizModpack {
    packHash = "sha256-/gQw/FeNv/jbschhFzujloO9jaqTmfvBbzouWUJGr6w=";
    url = "https://git.satr14.my.id/satr14/server-modpack/raw/${path}/pack.toml";
  };
in {
  imports = [ inputs.mc.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.mc.overlay ];
  
  powerManagement.cpuFreqGovernor = "powersave"; # performance governor causes overheating and thermal throttling, works fine with powesave
  boot.kernel.sysctl = {
    "vm.nr_hugepages" = (ram-allocation-mb / 2) + 512; # (heap_mb / 2MB per page) + 512 pages (1GB) for ZGC off-heap overhead
    "vm.swappiness" = 10;
  };

  systemd.services."minecraft-server-${name}".environment = {
    LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
  }; # ^^^ physics mod fix
  
  services.minecraft-servers = {
    enable = true;
    eula = true;
    managementSystem.systemd-socket.enable = true;
    # ^^^ https://github.com/Infinidoge/nix-minecraft/issues/119
    
    # TODO: figure out how to set gamerules on start
    # gamerules to disable: locator_bar, mob_explosion_drop_decay, (and possibly) reduced_debug_info, global_sound_events 
    # gamerules to enable (temporarily): noend:disable_end
   
    servers.${name} = {
      enable = true;
      autoStart = true;
      restart = "always";
      enableReload = production;
      
      operators = lib.mkIf (!production) {
        "satr14" = {
          uuid = "54441a30-fe73-46e7-adca-c476bd4fc6d2";
          bypassesPlayerLimit = true;
          level = 4;
        };
      };
      
      serverProperties = {
        server-port = 25565;
        server-name = name;
        motd = "§cCan't connect to server";
        log-ips = true;
        hide-online-players = true; 
        
        difficulty = "normal";
        gamemode = "survival";
        max-world-size = 25000;
        spawn-protection = 0;
        pvp = true;
        
        online-mode = true;
        enable-query = true;
        enforce-secure-profile = false;
        pevent-proxy-connections = false;
        allow-flight = false;
        player-idle-timeout = 0;
        
        view-distance = 12;
        simulation-distance = 6;
        
        enable-rcon = true;
        sync-chunk-writes = false;
        "rcon.password" = rcon-pass;
        "rcon.port" = 25575;
      };
      
      symlinks = inputs.mc.lib.collectFilesAt modpack "mods" // {
        "polymer/packsquash" = let 
          packsquash-binary = pkgs.runCommand "packsquash" {
            src = pkgs.fetchurl {
              url = "https://github.com/ComunidadAylas/PackSquash/releases/download/v0.4.1/packsquash-x86_64-unknown-linux-gnu.zip";
              sha256 = "sha256-VsGZewoiO5MjhIhwjlLO5d5uHynlAK5Jh16jH2k2rPs=";
            };
            nativeBuildInputs = [ pkgs.unzip ];
          } ''
            mkdir -p $out/bin
            unzip $src -d $out/bin
            chmod +x $out/bin/packsquash
          '';
        in "${packsquash-binary}/bin/packsquash";
      };

      files = inputs.mc.lib.collectFilesAt modpack "config" // {
        "config/proxy_protocol_support.json".value = {
          enableProxyProtocol = false; # polymer auto host has issues with proxy protocol
          whitelistTCPShieldServers = false;
          proxyServerIPs = [
            "127.0.0.1" "::1"
            "127.185.172.53" # playit
          ];
          directAccessIPs = [
            "127.0.0.0/8" "::1/128" # localhost
            "100.64.0.0/10" "fd7a:115c:a1e0::/48" # tailscale
            "192.168.1.0/24" "10.3.14.0/24" # lan
          ];
        };
      };
      
      extraStartPre = let sed-commands = lib.concatStringsSep "\n" (
        lib.mapAttrsToList (placeholder: file: 
          ''sed -i "s|${placeholder}|''${${placeholder}}|g" ${file}''
        ) {
          "REPLACE_SVC_HOST"      = "config/voicechat/voicechat-server.properties";
          "REPLACE_RP_LINK"       = "config/welcomemessage.json5";
          "REPLACE_DC_BOT_TOKEN"  = "config/simple-discord-link/simple-discord-link.toml";
          "REPLACE_DC_OWNER_ROLE" = "config/simple-discord-link/simple-discord-link.toml";
        }
      ); in ''
        # shellcheck disable=SC1091
        source modpack-config.env
        ${sed-commands}
      '';
      
      package = pkgs.fabricServers.fabric-1_21_11.override {
        jre_headless = pkgs.javaPackages.compiler.temurin-bin.jdk-25;
        loaderVersion = "0.19.2";
      };

      jvmOpts = let flags = [
        "-Xms${toString ram-allocation-mb}M"
        "-Xmx${toString ram-allocation-mb}M"
        
        "-XX:+UseZGC" # Use ZGC (requires Java v25+, 8+ CPU cores, 10GB+ RAM)
        "-XX:+UseCompactObjectHeaders" # Use compact object headers (requires Java v16+, saves a couple of bits per object)
        
        "--add-modules=jdk.incubator.vector" # Exposes SIMD instructions (requires full JDK, useful with performance mods)
        "-XX:+UseLargePages" # Large pages support (requires hugepages configured on the system)
        "-XX:+AlwaysPreTouch" # Pre-allocates memory on startup, OS claims it immediately for JVM instead of negotiating it
        "-XX:+DisableExplicitGC" # Disables mods from manually invoking the GC
        "-XX:+PerfDisableSharedMem" # Disables constant /tmp writes for JVM metrics
        "-XX:ZAllocationSpikeTolerance=5" # Helps when server is active with many players
        "-XX:SoftMaxHeapSize=${toString (ram-allocation-mb - 2048)}M" # Leave 2GB headroom
        "-XX:ZCollectionInterval=1" # Force a GC cycle at minimum every second
        "-XX:ConcGCThreads=8" # Threads ZGC uses for concurrent work
      ]; in lib.concatStringsSep " " flags;
    };
  };
}