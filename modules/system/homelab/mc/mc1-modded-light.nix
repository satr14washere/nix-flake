{ inputs, lib, pkgs, ... }: let
  name = "mc1-pure-vanilla";
  ram-allocation-mb = 12288;
  headroom-allocation-mb = 2048;
  rcon-pass = "howdy";
  ports = {
    minecraft = 25565;
    rcon = 25575;
  };
  
  modpack = pkgs.fetchModrinthModpack {
    url = "https://cdn.modrinth.com/data/2wkV8mHp/versions/mFGJP1Ye/Server%20Optimization%201.21.11-2.1.mrpack";
    packHash = "sha256-odvJs6s1/T13RQhE3NnpCIrulc98nd9vo9Alg/aU404=";
    side = "server";
  };
in {
  services.minecraft-servers.servers.${name} = {
    enable = false;
    autoStart = true;
    restart = "always";
    
    serverProperties = {
      server-ip = "0.0.0.0";
      server-port = ports.minecraft;
      server-name = name;
      motd = "§cCan't connect to server";
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
      "rcon.port" = ports.rcon;
    };
    
    files = inputs.mc.lib.collectFilesAt modpack "config";
    symlinks = inputs.mc.lib.collectFilesAt modpack "mods" // {
      mods = pkgs.linkFarmFromDrvs "mods" (builtins.attrValues {
      	# NAME = pkgs.fetchurl { url = ""; hash = ""; };

      	EffortlessBuilding = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/DYtfQEYj/versions/WFfB60HD/effortlessbuilding-4.1%2B1.21.11.jar"; hash = ""; };
      	SimpleVoiceChat = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/XhWdYnkC/voicechat-fabric-1.21.11-2.6.21.jar"; hash = ""; };

      	AudioPlayer = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/SRlzjEBS/versions/QDto44wD/audioplayer-fabric-2.4.0%2B1.21.11.jar"; hash = ""; };
      	Clifftree = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/59ypHk8x/versions/JZIwqnbs/CliffTree-3.1.5-1.21.11_MoM.jar"; hash = ""; };
      	Lithostiched = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/XaDC71GB/versions/pLbQKCOo/lithostitched-1.7.2-fabric-21.11.jar"; hash = ""; };
      	Tectonic = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/lWDHr9jE/versions/7olSYFxL/tectonic-3.0.19-fabric-1.21.11.jar"; hash = "sha256-p0WQfF8uX9saB4b6Ms4AoDiQ4w8bh+bA6hDKoH3CmtY="; };

      	CraterLib = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/Nn8Wasaq/versions/NPIPYNKe/CraterLib-Fabric-1.21.11-3.1.2.jar"; hash = ""; };
      	SimpleDiscordLink = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/Sh0YauEf/versions/w2ngBoyZ/SimpleDiscordLink-Universal-3.4.4.jar"; hash = ""; };
      	TabTPS = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/cUhi3iB2/versions/hTiqRp4H/tabtps-fabric-mc1.21.11-1.3.30.jar"; hash = ""; };
      	SkinRestorer = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/ghrZDhGW/versions/FyV19hQI/skinrestorer-2.9.0%2B1.21.11-fabric.jar"; hash = ""; };
        EasyAuth = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/aZj58GfX/versions/R4EX0C3V/easyauth-mc1.21.11-3.4.3.jar"; hash = "sha256-T1PfPlyfkieOCsfoab+BpW8pB/CSDKlxGrS5FMgSMEU="; };
        Floodgate = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/bWrNNfkb/versions/81EuNxeZ/Floodgate-Fabric-2.2.6-b60.jar"; hash = "sha256-voH1QWv5GVm6EziJ3ERPjn5cx09/et73QiZlJ7l3foM="; };
        Geyser = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/wKkoqHrH/versions/6uw7I3Qj/geyser-fabric-Geyser-Fabric-2.9.6-b1133.jar"; hash = "sha256-aWMlDdHvNz6VaLVPdmO01YBAlQ7m4w8aUe47TbXxM60="; };
      });
    };
    
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
