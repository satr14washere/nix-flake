{ homelab, ... }: {
  services.forgejo = {
    enable = true;
    settings = {
      server = {
        DISABLE_SSH = true;
        DOMAIN = "git.proxy.${homelab.domain}";
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 5080;
        PROTOCOL = "http";
        ROOT_URL = "https://git.${homelab.domain}";
        LANDING_PAGE = "explore";
      };
      oauth2_client.ENABLE_AUTO_REGISTRATION=true;
      service = {
        # DISABLE_REGISTRATION = true;
        # ENABLE_OPENID_SIGNIN = true;
        # ENABLE_OPENID_SIGNUP = true;
        # ENABLE_INTERNAL_SIGNIN = false;
        # SHOW_REGISTRATION_BUTTON = false;
        # ALLOW_ONLY_EXTERNAL_REGISTRATION = true;
        # ALLOW_ONLY_INTERNAL_REGISTRATION = false;
        # REQUIRE_EXTERNAL_REGISTRATION_PASSWORD = true;
      };
      ui = {
        # THEMES = "catppuccin-blue-auto,catppuccin-mocha-blue,catppuccin-sapphire-auto,catppuccin-mocha-sapphire,auto";
        # DEFAULT_THEME = "catppuccin-mocha-blue";
      };
      user.ENABLE_FOLLOWING=false;
      repository = {
        DISABLE_STARS = true;
        DISABLE_FORKS = true;
      };
    };
  };
}