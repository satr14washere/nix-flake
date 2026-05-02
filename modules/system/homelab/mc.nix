{ inputs, lib, pkgs, ... }: let
  ram-allocation = "10240M";
  auth-server = "https://mc.satr14.my.id";
  # modpack = pkgs.fetchPackwizModpack {
  #   url = "";
  #   packHash = "";
  # };
in {
  imports = [ inputs.mc.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.mc.overlay ];
  
  services.minecraft-servers = {
    enable = true;
    eula = true;
   
    servers.mc0-explorers-creativity = {
      enable = true;
      autoStart = true;
      restart = "always";
      enableReload = true;
      
      managementSystem.systemd-socket.enable = true; # Referenced but unset environment variable evaluates to an empty string: MAINPID
      package = pkgs.fabricServers.fabric-26_1.override { loaderVersion = "0.19.2"; };
      jvmOpts = let
        authlib-injector = pkgs.fetchurl {
          url = "https://github.com/yushijinhun/authlib-injector/releases/download/v1.2.7/authlib-injector-1.2.7.jar";
          sha256 = "0av58bz0fn7wn9bf7sib62cn4vgkk4mr9mavpn2xiizzmk2lpwga";
        };
        flags = [
          "-Xms${ram-allocation}"
          "-Xmx${ram-allocation}"
          "-javaagent:${authlib-injector}=${auth-server}"
          "--add-modules=jdk.incubator.vector"

          # Aikar's GC flags
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
        motd = "\u00a7lSeason 3\u00a7r - \u00a7dExplorers Creativity \ud83d\udd25";
        
        difficulty = "normal";
        gamemode = "survival";
        max-world-size = 25000;
        spawn-protection = 0;
        pvp = true;
        
        online-mode = true;
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
        # "mods" = "${modpack}/mods";
        
        # "server-icon.png" = "${modpack}/server-icon.png";
        # "config" = "";
      };
    };
  };
}