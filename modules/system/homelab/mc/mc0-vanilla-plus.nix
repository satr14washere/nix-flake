{ inputs, lib, pkgs, ... }: let
  name = "mc0-vanilla-plus";
  ram-allocation-mb = 8192;
  headroom-allocation-mb = 1024;
  rcon-pass = "howdy";
  modpack = let
    useLatest = false;
    commit = "bf95d65e758963899f9d5a4eba6b589c50faffc9";
    path = if !useLatest then "commit/${commit}" else "branch/main";
  in pkgs.fetchPackwizModpack {
    packHash = "";
    url = "https://git.satr14.my.id/satr14/server-modpack/raw/${path}/pack.toml";
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
      server-port = 25565;
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
        proxyServerIPs = [ "127.0.0.1" "::1" ];
        directAccessIPs = [ "127.0.0.0/8" "::1/128" ];
      };
    };
    
    extraStartPre = let sed-commands = lib.concatStringsSep "\n" (
      lib.mapAttrsToList (substitution: file: 
        ''sed -i "s|${substitution}|''${${substitution}}|g" ${file}''
      ) {
        "REPLACE_SVC_HOST"      = "config/voicechat/voicechat-server.properties";
        "REPLACE_RP_LINK"       = "config/welcomemessage.json5";
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