{ lib, ... }: {
  imports = [
    ./homelab/containers.nix
    ./homelab/gallery.nix
    ./homelab/remote.nix
    # ./homelab/media.nix # wip
    ./homelab/share.nix
    ./homelab/proxy.nix
    ./homelab/auth.nix
    ./homelab/dash.nix
    ./homelab/dns.nix
    ./homelab/git.nix
    ./homelab/ai.nix
    ./core/swapfile.nix
    ./misc/theme.nix
    ./base.nix
  ];

  specialisation.safe-mode.configuration = {};

  virtualisation = {
    oci-containers.backend = "docker";
    docker = {
      enable = true;
      autoPrune.enable = true;
      enableOnBoot = true;
    };
  };

  networking = {
    networkmanager.dns = "none";
    nameservers = lib.mkForce [ "127.0.0.1" ];
  };
}
