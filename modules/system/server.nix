{ lib, ... }: {
  imports = [
    ./homelab/share.nix
    ./homelab/proxy.nix
    ./homelab/dash.nix
    ./homelab/dns.nix
    ./homelab/git.nix
    ./homelab/idp.nix
    ./base.nix
  ];
  
  networking = {
    networkmanager.dns = "none";
    nameservers = lib.mkForce [ "127.0.0.1" ];
  };
}