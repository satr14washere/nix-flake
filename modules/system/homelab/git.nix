{ homelab, ... }: {
  services.forgejo = {
    enable = true;
    lfs.enable = true;
    stateDir = "/mnt/data/forgejo";
    settings = {
      server = {
        DISABLE_SSH = true;
        DOMAIN = "git.proxy.${homelab.domain}";
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 5080;
        PROTOCOL = "http";
        ROOT_URL = "https://git.proxy.${homelab.domain}";
        LANDING_PAGE = "explore";
      };
      oauth2_client.ENABLE_AUTO_REGISTRATION=true;
      service = {
        DISABLE_REGISTRATION = true;
        ENABLE_OPENID_SIGNIN = false;
        ENABLE_OPENID_SIGNUP = false;
        ENABLE_INTERNAL_SIGNIN = false;
        SHOW_REGISTRATION_BUTTON = false;
        ALLOW_ONLY_EXTERNAL_REGISTRATION = true;
        ALLOW_ONLY_INTERNAL_REGISTRATION = false;
        REQUIRE_EXTERNAL_REGISTRATION_PASSWORD = true;
      };
      user.ENABLE_FOLLOWING=false;
      repository = {
        DISABLE_STARS = true;
        DISABLE_FORKS = true;
      };
    };
  };
}