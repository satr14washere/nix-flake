{ ... }: {
  services = {
    guacamole-server = {
      enable = true;
      host = "127.0.0.1";
      port = 4822;
    };
    guacamole-client = {
      enable = true;
      host = "127.0.0.1";
      port = 8085;
      enableWebserver = true;
      settings = {
        guacd-hostname = "127.0.0.1";
        guacd-port = 4822;
      };
    };
  };
}