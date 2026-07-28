{ inputs, lib, pkgs, ... }: let
  name = "mc1-modded-light";
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
    enable = true;
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
      "mods/EffortlessBuilding.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/DYtfQEYj/versions/WFfB60HD/effortlessbuilding-4.1%2B1.21.11.jar"; hash = "sha256-nxp2tv/O5C++/5SKPixH8p96SGzSy26VOWsaho6SYqU="; };
      "mods/SimpleVoiceChat.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/XhWdYnkC/voicechat-fabric-1.21.11-2.6.21.jar"; hash = "sha256-06XtTXw2f4/CVFxED52AOLVxVnTVcr4BrdRgvb4bkRI="; };

      "mods/PlayerDropsHead.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/cz5Ve1NT/versions/cKab9P4U/player-drops-head-v3.6.2.1.jar"; hash = "sha256-71G5ptrmrq5uqhdQt7vGTfL/WaF41fE7rw8sJCJTEwo="; };
      "mods/AudioPlayer.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/SRlzjEBS/versions/QDto44wD/audioplayer-fabric-2.4.0%2B1.21.11.jar"; hash = "sha256-K/WbgU2kq9pKtT8yaP2noXt7g0bNOkmq/qWu0ox2Owk="; };
      "mods/Clifftree.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/59ypHk8x/versions/JZIwqnbs/CliffTree-3.1.5-1.21.11_MoM.jar"; hash = "sha256-5Hk84lmUPsBkiIBJgHI0WWy4ctO6j5KGhffyFViOsjw="; };
      "mods/Lithostiched.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/XaDC71GB/versions/pLbQKCOo/lithostitched-1.7.2-fabric-21.11.jar"; hash = "sha256-XWhxsnpsMy46d6+PxDIDME4/Xfh9kAI2lq08BpEcIYI="; };
      "mods/Tectonic.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/lWDHr9jE/versions/7olSYFxL/tectonic-3.0.19-fabric-1.21.11.jar"; hash = "sha256-p0WQfF8uX9saB4b6Ms4AoDiQ4w8bh+bA6hDKoH3CmtY="; };

      "mods/CraterLib.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/Nn8Wasaq/versions/NPIPYNKe/CraterLib-Fabric-1.21.11-3.1.2.jar"; hash = "sha256-96O47b2IUTD0TXehlFj8ToToQ2d4g3nuO6+a+XKmS8A="; };
      "mods/SimpleDiscordLink.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/Sh0YauEf/versions/w2ngBoyZ/SimpleDiscordLink-Universal-3.4.4.jar"; hash = "sha256-awmNrYgLl7waEEM+SeFAdgCaIDxcunIYO6UF2F2c4zQ="; };
      
      "mods/TabTPS.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/cUhi3iB2/versions/hTiqRp4H/tabtps-fabric-mc1.21.11-1.3.30.jar"; hash = "sha256-XgOF29UlvU00iZAkfZU78uXv8nX79uFXJUJBsqSp5Ac="; };
      "mods/SkinRestorer.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/ghrZDhGW/versions/FyV19hQI/skinrestorer-2.9.0%2B1.21.11-fabric.jar"; hash = "sha256-yRL2k6uROnVBqjgFp1i8dMucubs5OYqZnT0wuBP0b0M="; };
      
      "mods/EasyAuth.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/aZj58GfX/versions/R4EX0C3V/easyauth-mc1.21.11-3.4.3.jar"; hash = "sha256-T1PfPlyfkieOCsfoab+BpW8pB/CSDKlxGrS5FMgSMEU="; };
      "mods/ViaFabric.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/YlKdE5VK/versions/U1uUiwCm/ViaFabric-0.4.21%2B173-1.14-1.21.jar"; hash = "sha256-PZSsCBuU+TSDAvAFGGCXFYi1zwDixpKsH2G97H3zSxo="; };
      "mods/Floodgate.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/bWrNNfkb/versions/81EuNxeZ/Floodgate-Fabric-2.2.6-b60.jar"; hash = "sha256-voH1QWv5GVm6EziJ3ERPjn5cx09/et73QiZlJ7l3foM="; };
      "mods/Geyser.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/YlKdE5VK/versions/ghuh2MQh/ViaFabric-0.4.21%2B171-1.14-1.21.jar"; hash = "sha256-9LHsJuz5egNzams1rzveyp43RhVl+4UovhCI5CDmqDg="; };
    };
    
    package = pkgs.fabricServers.fabric-1_21_11.override {
      jre_headless = pkgs.javaPackages.compiler.temurin-bin.jdk-21;
      loaderVersion = "0.19.2";
    };

    jvmOpts = let flags = [
      "-Xms${toString ram-allocation-mb}M"
      "-Xmx${toString ram-allocation-mb}M"
      
      "-XX:+UseZGC" # Use ZGC (requires Java v15+, 8+ CPU cores, 10GB+ RAM)
      "-XX:+ZGenerational" # Use generational ZGC (newer and better ZGC, requires Java v21+)
      # "-XX:+UseCompactObjectHeaders" # Use compact object headers (requires Java v25+, saves a couple of bits per object)
      
      "--add-modules=jdk.incubator.vector" # Exposes SIMD instructions (requires full JDK, useful with performance mods like C2ME)
      "-XX:+AlwaysPreTouch" # Pre-allocates memory on startup, OS claims it immediately for JVM instead of negotiating it
      "-XX:+DisableExplicitGC" # Disables mods from manually invoking the GC
      "-XX:+PerfDisableSharedMem" # Disables constant /tmp writes for JVM metrics
      "-XX:SoftMaxHeapSize=${toString (ram-allocation-mb - headroom-allocation-mb)}M" # Leave 2GB headroom
    ]; in lib.concatStringsSep " " flags;
  };
}
