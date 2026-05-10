{ inputs, lib, pkgs, ... }: let
  ram-allocation-mb = 12288;
  rcon-pass = "howdy";
  modpack = let
    commit = "ac9278758cf96b97fbb4f816aca0fb2f94ccf3a2";
  in pkgs.fetchPackwizModpack {
    packHash = "";
    url = "https://git.satr14.my.id/satr14/server-modpack/raw/commit/${commit}/pack.toml";
  };
  
in {
  imports = [ inputs.mc.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.mc.overlay ];
  
  powerManagement.cpuFreqGovernor = "schedutil";
  boot.kernel.sysctl = {
    "vm.nr_hugepages" = (ram-allocation-mb / 2) + 512; # (heap_mb / 2MB per page) + 512 pages (1GB) for ZGC off-heap overhead
    "vm.swappiness" = 10;
  };
  
  services.minecraft-servers = {
    enable = true;
    eula = true;
    managementSystem.systemd-socket.enable = true; # Referenced but unset environment variable evaluates to an empty string: MAINPID
    # ^^^ https://github.com/Infinidoge/nix-minecraft/issues/119
   
    servers.mc0-explorers-creativity = {
      enable = true;
      autoStart = true;
      restart = "always";
      enableReload = true; # NOTE: development phase, disable in production
      
      package = pkgs.fabricServers.fabric-1_21_11.override {
        jre_headless = pkgs.javaPackages.compiler.temurin-bin.jdk-25;
        loaderVersion = "0.19.2";
      };

      jvmOpts = let flags = [
        "-Xms${toString ram-allocation-mb}M"
        "-Xmx${toString ram-allocation-mb}M"

        # Exposes SIMD instructions (requires full JDK, useful with performance mods)
        "--add-modules=jdk.incubator.vector"

        # ZGC flags (requires Java v25+, 8+ CPU cores, 10GB+ RAM)
        "-XX:+UseZGC"
        "-XX:+UseLargePages"
        "-XX:+AlwaysPreTouch"
        "-XX:+DisableExplicitGC"
        "-XX:+PerfDisableSharedMem"
        "-XX:+UseCompactObjectHeaders"
        "-XX:ZAllocationSpikeTolerance=5"
        "-XX:SoftMaxHeapSize=${toString (ram-allocation-mb - 2048)}M"

        # High MSPT due to ZGC pauses
        "-XX:ZUncommitDelay=300"
        "-XX:ZCollectionInterval=5"
      ]; in lib.concatStringsSep " " flags;

      # extraStartPost = let gamerules = {
      #   "locator_bar" = false;
      #   "mob_explosion_drop_decay" = false;
      #   # "reduced_debug_info" = false;
      #   # "global_sound_events" = false;
      # }; in lib.concatStringsSep "\n" (map
      #   (rule: "${pkgs.rcon-cli}/bin/rcon-cli --password ${rcon-pass} gamerule ${rule} ${toString (gamerules.${rule})}")
      #   (lib.attrNames gamerules)
      # );
      # TODO: figure out how to set gamerules on start (script above runs **before** server ready)
      
      serverProperties = {
        server-port = 25565;
        server-name = "Minecraft Server";
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
        
        view-distance = 12;
        simulation-distance = 4;
        
        enable-rcon = true;
        sync-chunk-writes = false;
        "rcon.password" = rcon-pass;
        "rcon.port" = 25575;
      };
      
      symlinks = {
        # "server-icon.png" = "${modpack}/server-icon.png";
        "mods" = "${modpack}/mods";
      };
    };
  };
}