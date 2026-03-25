![nix-flake](ss.png)
rewrite of my nixos flake with hopefully better structuring and modularity

> [!WARNING]
> this flake is ment for personal use. code is not well documented and is not ment to be used by others. use at your own risk.

## hosts
- `thinkpad` - my thinkpad t480 with an i5 8350u, 16gb of ram, and 256gb nvme ssd (140 allocated for nixos, rest for windows 11)
- `homelab` - my homelab server in a vm on a proxmox host with an i7 8700t, 32gb of ram, and 512gb boot drive (with hotplug enabled for cpu and ram)

## credits
- [orangc's flake](https://git.orangc.net/c/dots)