{ inputs, lib, pkgs, ... }: let
  name = "mc0-vanilla-plus";
  production = true;
  ram-allocation-mb = 12288;
  rcon-pass = "howdy";
  modpack = let
    commit = "a22477190ee93aed8d1c33687f1824550f0712cf";
    path = if production then "commit/${commit}" else "branch/main";
  in pkgs.fetchPackwizModpack {
    packHash = "sha256-9bPnK3xohEcwrFc5LoXemIzQwQullJmuoJ8zjEoIV/U=";
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

  systemd.services = {
    lazymc = let
      wrapperCommand = pkgs.writeShellScript "lazymc-${name}-wrapper" ''
        #!/usr/bin/env bash
        trap 'systemctl stop --wait "minecraft-server-${name}"; exit 0' SIGTERM
        systemctl start "minecraft-server-${name}"
        while systemctl is-active --quiet "minecraft-server-${name}"; do sleep 1; done
      '';
      config = {
        public = {
          address = "0.0.0.0:25565"; # external proxy port
          version = "1.21.11";
        };
        server = {
          wake_whitelist = true;
          address = "127.0.0.1:25566"; # internal server port
          directory = "/srv/minecraft/${name}";
          command = wrapperCommand;
        };
        time.sleep_after = 600;
        motd.from_server = true;
        join = {
          methods = [ "hold" ];
          hold.timeout = 60;
        };
        advanced.rewrite_server_properties = false; # might get overridden by nix-minecraft
        config.version = "0.2.11";
      };
    in {
      description = "Wake-up Proxy for Minecraft Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        User = "root";
        Group = "root";
        ExecStart = let
          toml = pkgs.formats.toml {};
          configFile = toml.generate "lazymc-${name}.toml" config;
        in "${pkgs.lazymc}/bin/lazymc --config ${configFile}"; 
        Restart = "always";
      };
    };
    "minecraft-server-${name}" = {
      environment.LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib"; # physics toys mod fix
      serviceConfig = {
        # Nice = -5; # higher scheduling priority
        TimeoutStopSec = 180; # just in case saving takes a while
      };
    };
  };
  
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
      autoStart = false;
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
        server-ip = "127.0.0.1";
        server-port = 25566;
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
        "polymer/packsquash" = let packsquash-binary = pkgs.runCommand "packsquash" {
          src = pkgs.fetchurl {
            url = "https://github.com/ComunidadAylas/PackSquash/releases/download/v0.4.1/packsquash-x86_64-unknown-linux-gnu.zip";
            sha256 = "sha256-VsGZewoiO5MjhIhwjlLO5d5uHynlAK5Jh16jH2k2rPs=";
          };
          nativeBuildInputs = [ pkgs.unzip ];
        } ''
          mkdir -p $out/bin
          unzip $src -d $out/bin
          chmod +x $out/bin/packsquash
        ''; in "${packsquash-binary}/bin/packsquash";
      };

      files = inputs.mc.lib.collectFilesAt modpack "config" // {
        "config/proxy_protocol_support.json".value = {
          enableProxyProtocol = false; # polymer auto host has issues with proxy protocol
          whitelistTCPShieldServers = false;
          proxyServerIPs = [
            "127.0.0.1" "::1"
          ];
          directAccessIPs = [
            "127.0.0.0/8" "::1/128" # localhost
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
        if [ -f modpack-config.env ]; then
          source modpack-config.env
          ${sed-commands}
        fi
      '';
      
      package = pkgs.fabricServers.fabric-1_21_11.override {
        jre_headless = pkgs.javaPackages.compiler.temurin-bin.jdk-25;
        loaderVersion = "0.19.2";
      };

      jvmOpts = let flags = [
        "-Xms${toString ram-allocation-mb}M"
        "-Xmx${toString ram-allocation-mb}M"
        
        "-XX:+UseZGC" # Use ZGC (requires Java v25+, 8+ CPU cores, 10GB+ RAM)
        "-XX:+ZGenerational" # Use generational ZGC (newer and better ZGC, requires Java v21+)
        "-XX:+UseCompactObjectHeaders" # Use compact object headers (requires Java v16+, saves a couple of bits per object)
        
        "--add-modules=jdk.incubator.vector" # Exposes SIMD instructions (requires full JDK, useful with performance mods like C2ME)
        "-XX:+UseLargePages" # Large pages support (requires hugepages configured on the system)
        "-XX:+AlwaysPreTouch" # Pre-allocates memory on startup, OS claims it immediately for JVM instead of negotiating it
        "-XX:+DisableExplicitGC" # Disables mods from manually invoking the GC
        "-XX:+PerfDisableSharedMem" # Disables constant /tmp writes for JVM metrics
        "-XX:SoftMaxHeapSize=${toString (ram-allocation-mb - 2048)}M" # Leave 2GB headroom
        # "-XX:ZAllocationSpikeTolerance=5" # Helps when server is active with many players
        # "-XX:ZCollectionInterval=1" # Force a GC cycle at minimum every second
        # "-XX:ConcGCThreads=8" # Threads ZGC uses for concurrent work
      ]; in lib.concatStringsSep " " flags;
    };
  };
}