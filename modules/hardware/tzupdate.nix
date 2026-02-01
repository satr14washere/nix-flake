{ lib, ... }: {
  time.timeZone = lib.mkForce null;
  services.tzupdate = {
    enable = true;
    timer.enable = true;
  };
}