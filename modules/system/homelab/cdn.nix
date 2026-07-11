{ inputs, pkgs, ... }: {
  environment.systemPackages = with pkgs; [ copyparty-most ];
  nixpkgs.overlays = [ inputs.cp.overlays.default ];
  imports = [ inputs.cp.nixosModules.default ];

  systemd.services.copyparty = {
    description = "File Sharing Service";
    enable = true;
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.copyparty}/bin/copyparty -c /mnt/share/cfg/files.conf";
      Restart = "on-failure";
    };
  };
}
