{ ... }: {
  services = {
    guacamole-server = {
      enable = true;
      host = "127.0.0.1";
      port = 4822;
    };
    guacamole-client = {
      enable = true;
      enableWebserver = true;
      userMappingXml = "/mnt/data/guacamole/user-mapping.xml";
      settings = {
        guacd-hostname = "127.0.0.1";
        guacd-port = 4822;
      };
    };
    tomcat.port = 8085;
  };
}