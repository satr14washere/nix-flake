{ inputs, lib, pkgs, ... }: let
  name = "mc2-create-aeronautics";
  ram-allocation-mb = 12288;
  headroom-allocation-mb = 2048;
  rcon-pass = "howdy";
  ports = {
    minecraft = 25565;
    rcon = 25575;
  };
  
  modpack = let
    useLatest = true;
    commit = "93a425aaad07dc39560a033c5a2f3bd5ae84531e";
    path = if !useLatest then "commit/${commit}" else "branch/main";
  in pkgs.fetchPackwizModpack {
    packHash = "";
    url = "https://git.satr14.my.id/satr14/server-modpack/raw/${path}/iu-s4/pack.toml";
  };
in {
  systemd.services."minecraft-server-${name}" = {
    environment.LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib"; # physics toys mod fix
    # serviceConfig.Nice = -5; # higher scheduling priority (causes fan noise even when idle)
  };
  
  services.minecraft-servers.servers.${name} = {
    enable = true;
    autoStart = true;
    restart = "always";
    
    serverProperties = {
      server-ip = "0.0.0.0";
      server-port = ports.minecraft;
      server-name = name;
      motd = "Season 4 - §b§lFlying Machines";
      log-ips = false;
      hide-online-players = true; 
      
      difficulty = "normal";
      gamemode = "survival";
      max-world-size = 25000;
      spawn-protection = 0;
      pvp = true;
      
      online-mode = false;
      enable-query = false;
      enforce-secure-profile = false;
      pevent-proxy-connections = false;
      allow-flight = false;
      player-idle-timeout = 0;
      
      view-distance = 12;
      simulation-distance = 6;
      
      enable-rcon = true;
      sync-chunk-writes = false;
      "rcon.password" = rcon-pass;
      "rcon.port" = ports.rcon;
    };
    
    symlinks = inputs.mc.lib.collectFilesAt modpack "mods";
    files = inputs.mc.lib.collectFilesAt modpack "config";
    
    extraStartPre = let sed-commands = lib.concatStringsSep "\n" (
      lib.mapAttrsToList (substitution: file: 
        ''sed -i "s|${substitution}|''${${substitution}}|g" ${file}''
      ) {
        "REPLACE_SVC_HOST"      = "config/voicechat/voicechat-server.properties";
        "REPLACE_DC_BOT_TOKEN"  = "config/simple-discord-link/simple-discord-link.toml";
        "REPLACE_DC_OWNER_ROLE" = "config/simple-discord-link/simple-discord-link.toml";
      }
    ); in ''
      # shellcheck disable=SC1091
      if [ -f modpack-config.env ]; then
        source modpack-config.env
        ${sed-commands}
      fi
    '';
    
    package = pkgs.fabricServers.neoforge-1_21_1.override {
      jre_headless = pkgs.javaPackages.compiler.temurin-bin.jdk-25;
      loaderVersion = "21.1.248";
    };

    jvmOpts = let flags = [
      "-Xms${toString ram-allocation-mb}M"
      "-Xmx${toString ram-allocation-mb}M"
      
      "-XX:+UseZGC" # Use ZGC (requires Java v25+, 8+ CPU cores, 10GB+ RAM)
      "-XX:+ZGenerational" # Use generational ZGC (newer and better ZGC, requires Java v21+)
      "-XX:+UseCompactObjectHeaders" # Use compact object headers (requires Java v16+, saves a couple of bits per object)
      
      "--add-modules=jdk.incubator.vector" # Exposes SIMD instructions (requires full JDK, useful with performance mods like C2ME)
      "-XX:+AlwaysPreTouch" # Pre-allocates memory on startup, OS claims it immediately for JVM instead of negotiating it
      "-XX:+DisableExplicitGC" # Disables mods from manually invoking the GC
      "-XX:+PerfDisableSharedMem" # Disables constant /tmp writes for JVM metrics
      "-XX:SoftMaxHeapSize=${toString (ram-allocation-mb - headroom-allocation-mb)}M" # Leave 2GB headroom
    ]; in lib.concatStringsSep " " flags;
  };
}