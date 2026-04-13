{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ copyparty-most ];

  # TODO: systemd service
}
