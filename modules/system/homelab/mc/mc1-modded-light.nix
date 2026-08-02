{ lib, pkgs, ... }: let
  name = "mc1-modded-light";
  ram-allocation-mb = 12288;
  headroom-allocation-mb = 2048;
  rcon-pass = "howdy";
  ports = {
    minecraft = 25565;
    rcon = 25575;
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
    
    symlinks = {
      # "mods/.jar" = pkgs.fetchurl { url = ""; hash = ""; };
      
      "mods/FabricLanguageKotlin.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/Ha28R6CL/versions/bdhiINYC/fabric-language-kotlin-1.13.13%2Bkotlin.2.4.10.jar"; hash = "sha256-NMzazxO7k1H+Q85hkSwuCbcjZOQ+eH02uj0tBN7HWlI="; };
      "mods/PuzzlesLib.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/QAGBst4M/versions/xTX7sOwU/PuzzlesLib-v21.11.13-mc1.21.11-Fabric.jar"; hash = "sha256-HHsGL01P1Mgw26qHXaAXBu+F8HKWkZHYwa/+9pOma4I="; };
      "mods/ForgeConfigAPIPort.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/ohNO6lps/versions/uXrWPsCu/ForgeConfigAPIPort-v21.11.1-mc1.21.11-Fabric.jar"; hash = "sha256-MaBoaQT60c/esdawEawcIoCZDW52rCQWRoFH4iRrTbE="; };
      "mods/Lithostiched.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/XaDC71GB/versions/pLbQKCOo/lithostitched-1.7.2-fabric-21.11.jar"; hash = "sha256-XWhxsnpsMy46d6+PxDIDME4/Xfh9kAI2lq08BpEcIYI="; };
      "mods/CraterLib.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/Nn8Wasaq/versions/NPIPYNKe/CraterLib-Fabric-1.21.11-3.1.2.jar"; hash = "sha256-96O47b2IUTD0TXehlFj8ToToQ2d4g3nuO6+a+XKmS8A="; };
      "mods/FabricAPI.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/6qAuTtLR/fabric-api-0.141.6%2B1.21.11.jar"; hash = "sha256-vf9/1+IgCFz60v+bH0Dd5lNK4Lls83j5ejdLxUy57Q8="; };
      
      "mods/EffortlessBuilding.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/DYtfQEYj/versions/WFfB60HD/effortlessbuilding-4.1%2B1.21.11.jar"; hash = "sha256-nxp2tv/O5C++/5SKPixH8p96SGzSy26VOWsaho6SYqU="; };
      "mods/SimpleVoiceChat.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/XhWdYnkC/voicechat-fabric-1.21.11-2.6.21.jar"; hash = "sha256-06XtTXw2f4/CVFxED52AOLVxVnTVcr4BrdRgvb4bkRI="; };
      "mods/SimpleDiscordLink.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/Sh0YauEf/versions/w2ngBoyZ/SimpleDiscordLink-Universal-3.4.4.jar"; hash = "sha256-awmNrYgLl7waEEM+SeFAdgCaIDxcunIYO6UF2F2c4zQ="; };

      "mods/PlayerDropsHead.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/cz5Ve1NT/versions/cKab9P4U/player-drops-head-v3.6.2.1.jar"; hash = "sha256-71G5ptrmrq5uqhdQt7vGTfL/WaF41fE7rw8sJCJTEwo="; };
      "mods/AudioPlayer.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/SRlzjEBS/versions/QDto44wD/audioplayer-fabric-2.4.0%2B1.21.11.jar"; hash = "sha256-K/WbgU2kq9pKtT8yaP2noXt7g0bNOkmq/qWu0ox2Owk="; };
      "mods/BetterMultiplayerSleep.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/LxB45e67/versions/MmaluIcb/BetterMultiplayerSleep%201.1.0%201.21.11%2B.jar"; hash = "sha256-xE9wZWb5Mszk8JonLV+yk/PxCkIDmzjA27DWU6DEij4="; };
      
      "mods/VeinMiner.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/OhduvhIc/versions/7c3RO0Qs/veinminer-fabric-2.11.2%2B1.21.11.jar"; hash = "sha256-ubLLSS+/VtNcg99EUmjTE0eAywtR4P/LQIWgqRqp1Wk="; };
      "mods/LeavesBeGone.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/AVq17PqV/versions/RhFHpbMN/LeavesBeGone-v21.11.0-mc1.21.11-Fabric.jar"; hash = "sha256-Ys/jz2aorlFRd1vlpHPAdQThMR9SaKQSFWcQDrLCRjo="; };
      
      "mods/VanillaStructureUpdate.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/q3gDW66d/versions/p9AB4oNm/vanilla-structure-update-v2.8.jar"; hash = "sha256-62PW2JW6zOpnguvcQL9pjCD/lCtc4RGYQeO/hmal3D4="; };
      "mods/Explorify.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/HSfsxuTo/versions/9vHj342y/Explorify%20v1.6.4%20f15-88.mod.jar"; hash = "sha256-3MU0DcdxxhNY9TuYGFlOnliNmvgcCh6QbDc/sU2b56M="; };
      "mods/Clifftree.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/59ypHk8x/versions/JZIwqnbs/CliffTree-3.1.5-1.21.11_MoM.jar"; hash = "sha256-5Hk84lmUPsBkiIBJgHI0WWy4ctO6j5KGhffyFViOsjw="; };
      "mods/Tectonic.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/lWDHr9jE/versions/7olSYFxL/tectonic-3.0.19-fabric-1.21.11.jar"; hash = "sha256-p0WQfF8uX9saB4b6Ms4AoDiQ4w8bh+bA6hDKoH3CmtY="; };

      "mods/TabTPS.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/cUhi3iB2/versions/hTiqRp4H/tabtps-fabric-mc1.21.11-1.3.30.jar"; hash = "sha256-XgOF29UlvU00iZAkfZU78uXv8nX79uFXJUJBsqSp5Ac="; };
      "mods/Vanish.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/UL4bJFDY/versions/WuwTqK6K/vanish-1.6.15%2B1.21.11.jar"; hash = "sha256-4U5XCZLR7A2INXm9f3V2ke1uBCCLt5SZSIa8Xa1ZEro="; };
      "mods/SkinRestorer.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/ghrZDhGW/versions/FyV19hQI/skinrestorer-2.9.0%2B1.21.11-fabric.jar"; hash = "sha256-yRL2k6uROnVBqjgFp1i8dMucubs5OYqZnT0wuBP0b0M="; };
      
      "mods/EasyAuth.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/aZj58GfX/versions/R4EX0C3V/easyauth-mc1.21.11-3.4.3.jar"; hash = "sha256-T1PfPlyfkieOCsfoab+BpW8pB/CSDKlxGrS5FMgSMEU="; };
      # "mods/ViaVersion.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/P1OZGk5p/versions/uz2jbJLI/ViaVersion-5.11.1-SNAPSHOT.jar"; hash = "sha256-xA5DOX2D3opxXldjVWytc3e579lKGy6o/84PtG3k4Vo="; };
      # "mods/ViaFabric.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/YlKdE5VK/versions/U1uUiwCm/ViaFabric-0.4.21%2B173-1.14-1.21.jar"; hash = "sha256-PZSsCBuU+TSDAvAFGGCXFYi1zwDixpKsH2G97H3zSxo="; };
      "mods/Floodgate.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/bWrNNfkb/versions/81EuNxeZ/Floodgate-Fabric-2.2.6-b60.jar"; hash = "sha256-voH1QWv5GVm6EziJ3ERPjn5cx09/et73QiZlJ7l3foM="; };
      # "mods/Geyser.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/wKkoqHrH/versions/6uw7I3Qj/geyser-fabric-Geyser-Fabric-2.9.6-b1133.jar"; hash = "sha256-aWMlDdHvNz6VaLVPdmO01YBAlQ7m4w8aUe47TbXxM60="; };

      "mods/VMP.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/wnEe9KBa/versions/7Cxc2cAR/vmp-fabric-mc1.21.11-0.2.0%2Bbeta.7.227-all.jar"; hash = "sha256-O7r2eBdx5SWKqoVWsZsYuZwaV+BFCzDWEsy4ek3e/hY="; };
      "mods/TabTPS20.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/YS3ZignI/versions/UIeIpr7z/tt20-0.8.4%2Bmc1.21.11-fabric.jar"; hash = "sha256-2kQBzPQ7dNmZz6SxeHsomFKL+UrwXzMmazg6SExQ+rE="; };
      "mods/Spark.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/l6YH9Als/versions/gonLOAU1/spark-1.10.170-fabric.jar"; hash = "sha256-U2UqZoLWmxqJJO6a6OYZJVUWOatUC9U/mBSxEpQ15+U="; };
      "mods/ServerCore.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/4WWQxlQP/versions/zg8VIycZ/servercore-fabric-1.5.15%2B1.21.11.jar"; hash = "sha256-78ehY/DFOdA8XsQsCS+b5WoP6GZrhxpjCCUC73kzBRA="; };
      "mods/ScalableLux.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/Ps1zyz6x/versions/ju27pK32/ScalableLux-fabric-0.3.0-alpha.0.3-all.jar"; hash = "sha256-FoZ4a6kxd0WPOGl3+biNGAwho5eDRZG+ul59wpqO0hI="; };
      "mods/Lithium.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/Ow7wA0kG/lithium-fabric-0.21.4%2Bmc1.21.11.jar"; hash = "sha256-UTXEHaW0PL3LKUJL3mUZUUOsQITiODTI6sBllCIBx4s="; };
      "mods/FerriteCore.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/uXXizFIs/versions/Ii0gP3D8/ferritecore-8.2.0-fabric.jar"; hash = "sha256-92vXYMv0goDMfEMYD1CJpGI1+iTZNKis89oEpmTCxxU="; };
      "mods/C2ME.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/VSNURh3q/versions/dO0K58An/c2me-fabric-mc1.21.11-0.4.0-alpha.0.23.jar"; hash = "sha256-HtZ5NZI9zhSvxqRf3w+Bqyg6KClCMO8mpfY7rYhNf6k="; };
      "mods/Chunky.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/fALzjamp/versions/1CpEkmcD/Chunky-Fabric-1.4.55.jar"; hash = "sha256-M8vZvODjNmhRxLWYYQQzNOt8GJIkjx7xFAO77bR2vRU="; };
      "mods/AlternateCurrent.jar" = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/r0v8vy1s/versions/YHZsmom1/alternate_current-mc1.21.11-1.9.0.jar"; hash = "sha256-J+RL5qN5luQPuY52nTAAK3NxhJDszdKR+PCDCvMixro="; };
    };
    
    package = pkgs.fabricServers.fabric-1_21_11.override {
      jre_headless = pkgs.javaPackages.compiler.temurin-bin.jdk-21;
      loaderVersion = "0.19.3";
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
