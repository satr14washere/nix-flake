{ ... }: {
  services.searx = {
    enable = true;
    redisCreateLocally = true;
    settings = {
      server = {
        bind_address = "127.0.0.1";
        port = 8091;
      };
      general = {
        debug = false;
        donation_url = false;
        contact_url = false;
        privacy_policy_url = false;
        enable_metrics = true;
      };
    };
  };
}