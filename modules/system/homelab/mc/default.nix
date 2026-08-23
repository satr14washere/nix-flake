{ inputs, ... }: {
  imports = [
    ./mc2-create-aeronautics.nix
    inputs.mc.nixosModules.minecraft-servers
  ];
  nixpkgs.overlays = [ inputs.mc.overlay ];

  services.minecraft-servers = {
    # LOCK IN
    enable = true;
    eula = true;
    managementSystem.systemd-socket.enable = true;
    # ^^^ https://github.com/Infinidoge/nix-minecraft/issues/119
  };
}