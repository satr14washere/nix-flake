{ inputs, pkgs, ... }: {
  nixpkgs.overlays = [ inputs.krnl.overlays.pinned ];
  boot.kernelPackages = pkgs.linuxPackages_zen;
  # boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v3;
  # boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-x86_64-v3;

  nix.settings = {
    substituters = [ "https://attic.xuyh0120.win/lantian" ];
    trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
  };

  environment.systemPackages = with pkgs; [
    scx-loader scx.full
  ];
  
  # services.scx = {
  #   enable = true;
  # };
}