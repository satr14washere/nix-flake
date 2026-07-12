{ pkgs, username, ... }: {
  users.users."${username}" = {
    linger = true;
    isNormalUser = true;
    description = "${username}";
    initialPassword = "${username}";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "minecraft"
      "wheel"
      "dialout"
      "libvirtd"
      "docker"
      "input"
      "uinput"
      "plugdev"
      "adbusers"
      "kvm"
      "video"
      "render"
    ];
  };
}
