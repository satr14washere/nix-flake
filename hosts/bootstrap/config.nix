{ pkgs, hostname, username, ... }: {
  imports = [ ../../hardware-configuration.nix ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11";
  time.timeZone = "Asia/Jakarta";
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };
  networking = {
    hostName = "${hostname}";
    networkmanager.enable = true;
  };
  environment.systemPackages = with pkgs; [
    vim git tmux htop
  ];
  services = {
    tailscale.enable = true;
    openssh = {
      enable = true;
      settings.PermitRootLogin = "prohibit-password";
    };
  };
  users.users."${username}" = {
    isNormalUser = true;
    initialPassword = "howdy";
    extraGroups = [ "wheel" ];
  };
}