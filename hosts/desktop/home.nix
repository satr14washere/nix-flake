{ pkgs, lib, ... }: {
  imports = [
    ../../modules/home
    ../../modules/home/desktop.nix
  ];

  # fixes paths/font/locale env vars on generic (non-NixOS) distros
  targets.genericLinux.enable = true;
}
