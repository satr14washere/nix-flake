{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # Disk & Storage
    baobab
    gnome-disk-utility
    gparted
    parted
    ntfs3g
    exfatprogs
    smartmontools
    ncdu
    ventoy-full-qt

    # System Monitoring & Hardware
    htop
    sysstat
    powertop
    lm_sensors
    fastfetch
    pciutils
    usbutils
    stress
    stress-ng

    # Networking
    gnome-network-displays
    ethtool
    dig
    dnslookup
    nmap
    netcat
    traceroute
    wakeonlan
    cloudflared
    cloud-utils

    # Archives & Compression
    file-roller
    zip
    unzip
    p7zip

    # GUI Utilities
    pavucontrol
    gucharmap
    lxappearance
    blueman
    shared-mime-info

    # Virtualization & Containers
    virt-viewer
    distrobox

    # Android
    android-tools
    scrcpy

    # Remote Access
    freerdp

    # Media
    ffmpeg

    # Printing
    hplipWithPlugin

    # CLI Essentials
    vim
    wget
    curl
    openssl_3
    coreutils-full
    jq
    lsof

    # Nix & Development
    dconf2nix
    home-manager
    nix-index
    nixd
    nil
    nh
    nvd
    git
  ];
}
