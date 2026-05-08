{ inputs, lib, pkgs, ... }: let
  ram-allocation-mb = 12288;
  modpack = let
    commit = "d1c0e4d6813e912a861345aa172eb52b83f93da9";
  in pkgs.fetchPackwizModpack {
    packHash = "";
    url = "https://git.satr14.my.id/satr14/server-modpack/raw/commit/${commit}/pack.toml";
  };
in {
  imports = [ inputs.mc.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.mc.overlay ];
  
  powerManagement.cpuFreqGovernor = "schedutil";
  boot.kernel.sysctl = {
    "vm.nr_hugepages" = 6656;
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
      ]; in lib.concatStringsSep " " flags;
      
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
        
        simulation-distance = 12;
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