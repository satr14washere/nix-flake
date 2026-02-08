{ ... }: {
  imports = [
    ../../modules/scans/thinkpad.nix
    ../../modules/hardware/thinkpad.nix
    
    ../../modules/system
    ../../modules/system/user.nix
  ];
}
