{ ... }: {
  services.searx = {
    enable = true;
    redisCreateLocally = true;
    environmentFile = "/mnt/data/apps/searxng/.env";
    settings = {
      server = {
        bind_address = "127.0.0.1";
        port = 8091;
        secret_key = "$SECRET_KEY";
      };
      general = {
        debug = false;
        donation_url = false;
        contact_url = false;
        privacy_policy_url = false;
        enable_metrics = true;
      };
      search.formats = [ "html" "json" ];
    };
    limiterSettings = {
      botdetection.ip_limit.link_token = false;
      botdetection.ip_lists = {
        block_ip = [ ];
        pass_ip = [ ];
      };
    };
  };
}