{ ... }: {
  imports = [
    ./homelab/containers.nix
    ./homelab/share.nix
    ./homelab/proxy.nix
    ./homelab/auth.nix
    ./homelab/dash.nix
    ./homelab/dns.nix
    ./homelab/git.nix
    ./base.nix
  ];
}