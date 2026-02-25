{ ... }: {
  imports = [
    ../../modules/scans/thinkpad.nix
    ../../modules/hardware/thinkpad.nix
    
    ../../modules/system/desktop.nix
    ../../modules/system/user.nix
  ];
}
