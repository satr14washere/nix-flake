{ inputs, lib, pkgs, ... }: let
  production = true;
  ram-allocation-mb = 12288;
  rcon-pass = "howdy";
  modpack = let
    commit = "8523f89493ace13087eb68cd9fe3b5eb4f669440";
    path = if production then "commit/${commit}" else "branch/main";
  in pkgs.fetchPackwizModpack {
    packHash = "sha256-xB9Oc/aneogSQ9r7L42vyVM6xwq+QkoTaXYNuUzeo6M=";
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
  
  services.minecraft-servers = {
    enable = true;
    eula = true;
    managementSystem.systemd-socket.enable = true;
    # ^^^ https://github.com/Infinidoge/nix-minecraft/issues/119
    
    # TODO: figure out how to set gamerules on start
    # gamerules to disable: locator_bar, mob_explosion_drop_decay, (and possibly) reduced_debug_info, global_sound_events 
    # gamerules to enable (temporarily): noend:disable_end
   
    servers.da-s3 = {
      enable = true;
      autoStart = true;
      restart = "always";
      enableReload = production;
      # extraReload = ''
      #   function rcon() {
      #     ${pkgs.rcon-cli}/bin/rcon-cli -p ${rcon-pass} $@
      #   }

      #   rcon "gamerule locator_bar false"
      #   rcon "gamerule mob_explosion_drop_decay false"
      #   rcon "gamerule reduced_debug_info false"
      #   rcon "gamerule global_sound_events false"
      # '';
      
      operators = lib.mkIf (!production) {
        "satr14" = {
          uuid = "54441a30-fe73-46e7-adca-c476bd4fc6d2";
          bypassesPlayerLimit = true;
          level = 4;
        };
      };
      
      serverProperties = {
        # server-ip = "localhost";
        server-port = 25565;
        server-name = "Minecraft Server";
        motd = "§lSeason 3§r - §dExplorers Creativity 🔥";
        log-ips = false; # TODO: figure out how to get ips from cloudflared tunnel
        
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
        simulation-distance = 4;
        
        enable-rcon = true;
        sync-chunk-writes = false;
        "rcon.password" = rcon-pass;
        "rcon.port" = 25575;
      };
      
      symlinks = lib.mapAttrs'
        (name: _: lib.nameValuePair "mods/${name}" "${modpack}/mods/${name}")
        (builtins.readDir "${modpack}/mods");
      
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