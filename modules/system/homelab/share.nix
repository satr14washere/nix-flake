{ ... }: {
  services = {
    httpd = {
      enable = true;
      virtualHosts."cdn" = {
        listen = [{ ip = "*"; port = 3000; }];
        documentRoot = "/mnt/share";
        extraConfig = ''
          Options +Indexes +FollowSymLinks
          Require all granted
        '';
      };
    };

    samba = {
      enable = true;
      settings = {
        global = {
          workgroup = "WORKGROUP";
          "disable netbios" = "yes";
          "allow insecure wide links" = "yes";
          "server min protocol" = "SMB2_02";
        };
        "NAS" = {
          path = "/mnt/share";
          browseable = "yes";
          "read only" = "no";
          "create mask" = "0664";
          "force create mode" = "0664";
          "directory mask" = "0775";
          "force directory mode" = "0775";
          "follow symlinks" = "yes";
          "wide links" = "yes";
        };
      };
    };
  };
}