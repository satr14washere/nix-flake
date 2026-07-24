{ inputs, ... }: {
  imports = [
    ./mc0-vanilla-plus.nix
    ./mc1-pure-vanilla.nix
    inputs.mc.nixosModules.minecraft-servers
  ];
  nixpkgs.overlays = [ inputs.mc.overlay ];

  services.minecraft-servers = {
    # LOCK IN
    enable = false;
    eula = true;
    managementSystem.systemd-socket.enable = true;
    # ^^^ https://github.com/Infinidoge/nix-minecraft/issues/119
  };
}