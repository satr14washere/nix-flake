{ inputs, ... }: {
  imports = [
    ./mc0-vanilla-plus.nix
    ./mc1-pure-vanilla.nix
    inputs.mc.nixosModules.minecraft-servers
  ];
  nixpkgs.overlays = [ inputs.mc.overlay ];
  
  powerManagement.cpuFreqGovernor = "powersave"; # performance governor causes overheating and thermal throttling, works fine with powesave
  boot.kernel.sysctl."vm.swappiness" = 10; # reduce swap usage and keep memory performance smooth

  services.minecraft-servers = {
    # LOCK IN
    enable = true;
    eula = true;
    managementSystem.systemd-socket.enable = true;
    # ^^^ https://github.com/Infinidoge/nix-minecraft/issues/119
  };
}