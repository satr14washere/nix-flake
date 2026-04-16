{ pkgs, ... }: {
  services.postgresql = {
    enable = true;
    dataDir = "/mnt/data/apps/postgresql"; 
    package = pkgs.postgresql_16;
  };
}