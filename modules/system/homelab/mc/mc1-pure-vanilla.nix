{ inputs, lib, pkgs, ... }: let
  name = "mc1-pure-vanilla";
  ram-allocation-mb = 8192;
  headroom-allocation-mb = 1024;
  rcon-pass = "howdy";
  
  modpack = pkgs.fetchModrinthModpack {
      url = "https://cdn.modrinth.com/data/2wkV8mHp/versions/mFGJP1Ye/Server%20Optimization%201.21.11-2.1.mrpack";
      packHash = "sha256-odvJs6s1/T13RQhE3NnpCIrulc98nd9vo9Alg/aU404=";
      side = "server";
    };
in {
  services.minecraft-servers.servers.${name} = {
    enable = true;
    autoStart = true;
    restart = "always";
    
    serverProperties = {
      server-ip = "0.0.0.0";
      server-port = 25566;
      server-name = name;
      motd = "Season 4 - §6§lPure Vanilla ⛏";
      log-ips = false;
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
      
      view-distance = 10;
      simulation-distance = 4;
      
      enable-rcon = true;
      sync-chunk-writes = false;
      "rcon.password" = rcon-pass;
      "rcon.port" = 25576;
    };
    
    symlinks = inputs.mc.lib.collectFilesAt modpack "mods"; # TODO: add cracked support
    files = inputs.mc.lib.collectFilesAt modpack "config";
    
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
      "-XX:+AlwaysPreTouch" # Pre-allocates memory on startup, OS claims it immediately for JVM instead of negotiating it
      "-XX:+DisableExplicitGC" # Disables mods from manually invoking the GC
      "-XX:+PerfDisableSharedMem" # Disables constant /tmp writes for JVM metrics
      "-XX:SoftMaxHeapSize=${toString (ram-allocation-mb - headroom-allocation-mb)}M" # Leave 2GB headroom
    ]; in lib.concatStringsSep " " flags;
  };
}