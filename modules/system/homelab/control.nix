{ homelab, pkgs, ... }: {
  services.cockpit = {
    enable = true;
    allowed-origins = [ "control.${homelab.proxy.base}" ];
    plugins = with pkgs; [
      cockpit-files cockpit-machines
    ];
  };
}