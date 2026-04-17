{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    baobab
    file-roller
    gnome-network-displays
    gnome-disk-utility
    
    parted
    smartmontools
    lm_sensors
    ntfs3g
    virt-viewer
    dconf2nix
    pciutils
    gparted
    exfatprogs
    pavucontrol
    jq
    powertop
    fastfetch
    ethtool
    dig
    dnslookup
    lsof
    gucharmap
    ncdu
    zip
    unzip
    blueman
    shared-mime-info
    usbutils
    cloudflared
    cloud-utils
    
    hplipWithPlugin

    android-tools
    scrcpy
    distrobox

    ventoy-full-qt
    ffmpeg
    vim
    wget
    curl
    openssl_3
    htop
    nmap
    sysstat
    netcat
    p7zip
    stress
    stress-ng
    wakeonlan
    coreutils-full
    traceroute
    lxappearance
    freerdp

    home-manager
    nix-index
    nixd
    nil
    nh
    nvd
    git
  ];
}
