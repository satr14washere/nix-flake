{ inputs, lib, pkgs, ... }: let
  ram-allocation = "10240M";
  # auth-server = "https://mc.satr14.my.id"; # TODO: self hosted drasl server
  modpack = let
    commit = "3ce321be116ec909aa2f2188b6d3e9351806dd7e";
  in pkgs.fetchPackwizModpack {
    packHash = "";
    url = "https://git.satr14.my.id/satr14/server-modpack/raw/commit/${commit}/pack.toml";
  };
in {
  imports = [ inputs.mc.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.mc.overlay ];
  
  services.minecraft-servers = {
    enable = true;
    eula = true;
    managementSystem.systemd-socket.enable = true; # Referenced but unset environment variable evaluates to an empty string: MAINPID
    # ^^^ https://github.com/Infinidoge/nix-minecraft/issues/119
   
    servers.mc0-explorers-creativity = {
      enable = true;
      autoStart = true;
      restart = "always";
      enableReload = false; # NOTE: development phase, disable in production
      
      package = pkgs.fabricServers.fabric-1_21_11.override {
        jre_headless = pkgs.javaPackages.compiler.temurin-bin.jre-25;
        loaderVersion = "0.19.2";
      };

      jvmOpts = let
        flags = [
          "-Xms${ram-allocation}"
          "-Xmx${ram-allocation}"
          "--add-modules=jdk.incubator.vector"
          
          # Custom auth server
          # "-Dminecraft.api.env=custom"
          # "-Dminecraft.api.auth.host=${auth-server}/auth"
          # "-Dminecraft.api.account.host=${auth-server}/account"
          # "-Dminecraft.api.profiles.host=${auth-server}/account"
          # "-Dminecraft.api.session.host=${auth-server}/session"
          # "-Dminecraft.api.services.host=${auth-server}/services"

          # Aikar's GC flags (tuned for 10GB)
          "-XX:+UseG1GC"
          "-XX:+ParallelRefProcEnabled"
          "-XX:MaxGCPauseMillis=200"
          "-XX:+UnlockExperimentalVMOptions"
          "-XX:+DisableExplicitGC"
          "-XX:+AlwaysPreTouch"
          "-XX:G1HeapWastePercent=5"
          "-XX:G1MixedGCCountTarget=4"
          "-XX:InitiatingHeapOccupancyPercent=15"
          "-XX:G1MixedGCLiveThresholdPercent=90"
          "-XX:G1RSetUpdatingPauseTimePercent=5"
          "-XX:SurvivorRatio=32"
          "-XX:+PerfDisableSharedMem"
          "-XX:MaxTenuringThreshold=1"
          "-Dusing.aikars.flags=https://mcflags.emc.gs"
          "-Daikars.new.flags=true"
          "-XX:G1NewSizePercent=30"
          "-XX:G1MaxNewSizePercent=40"
          "-XX:G1HeapRegionSize=8M"
          "-XX:G1ReservePercent=20"
        ];
      in lib.concatStringsSep " " flags;
      
      serverProperties = {
        server-port = 25565;
        server-name = "Digit Association";
        motd = "§lSeason 3 TESTING§r - §dExplorers Creativity 🔥";
        
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
        
        # resource-pack = "https://cdn.satr14.my.id/public/fullslide-1.21.11.zip";
        # resource-pack-sha1 = "e0958dcef5755286f390c22280700c471ec34a65";
        # resource-pack-enforce = false;
        
        simulation-distance = 16;
        view-distance = 4;
        
        enable-rcon = true;
        sync-chunk-writes = false;
        "rcon.password" = "howdy";
        "rcon.port" = 25575;
      };
      
      symlinks = {
        # "resources/datapack/required" = "${modpack}/datapacks";
        "mods" = "${modpack}/mods";
        
        # "server-icon.png" = "${modpack}/server-icon.png";
        # "config" = "";
      };
    };
  };
}