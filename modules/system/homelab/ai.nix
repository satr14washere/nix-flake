{ homelab, ... }: {
  services = {
    ollama = {
      enable = true;
      host = "127.0.0.1";
      port = 11434;
      home = "${homelab.disks.data}/ollama";
      # loadModels = [ "gemma3n:e4b" "gemma3n:e2b"  ];
    };
    open-webui = {
      enable = true;
      port = 8080;
      environment = {
        OLLAMA_BASE_URL = "http://localhost:11434";
        WEBUI_AUTH = "False";
        
      };
    };
  };
}