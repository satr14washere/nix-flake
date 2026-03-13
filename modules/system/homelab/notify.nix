{ homelab, ... }: {
  services.ntfy-sh = {
    enable = true;
    settings = {
      listen-http = "127.0.0.1:8067";
      base-url = "https://ntfy.proxy.${homelab.domain}";
    };
  };
}