{ homelab, pkgs, ... }: {
  services.cockpit = {
    enable = true;
    allowed-origins = [ "https://control.proxy.${homelab.domain}" ];
    plugins = with pkgs; [
      cockpit-files cockpit-machines
    ];
  };
}