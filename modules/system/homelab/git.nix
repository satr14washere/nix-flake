{ pkgs, homelab, ... }: {
  security.sudo.extraRules = [{ # for configuration activation on push to git
    users = [ "gitea-runner" ]; 
    commands = [{ 
      command = "/run/current-system/sw/bin/nixos-rebuild"; 
      options = [ "NOPASSWD" ]; 
    }];
  }];
  services = {
    forgejo = {
      enable = true;
      lfs.enable = true;
      stateDir = "/mnt/data/forgejo";
      package = pkgs.forgejo;
      #secrets = {
      #  oauth2.JWT_SECRET = "/mnt/data/forgejo/custom/conf/oauth2_jwt_secret";
      #  server.LFS_JWT_SECRET = "/mnt/data/forgejo/custom/conf/lfs_jwt_secret";
      #  security = {
      #    INTERNAL_TOKEN = "/mnt/data/forgejo/custom/conf/internal_token";
      #    SECRET_KEY = "/mnt/data/forgejo/custom/conf/secret_key";
      #  };
      #};
      settings = {
        server = {
          DISABLE_SSH = false;
          START_SSH_SERVER = true;
          SSH_DOMAIN = "main.dns.${homelab.domain}";
          SSH_LISTEN_HOST = "0.0.0.0";
          SSH_LISTEN_PORT = 5822;
          SSH_PORT = 5822;
          DOMAIN = "git.${homelab.domain}";
          HTTP_ADDR = "127.0.0.1";
          HTTP_PORT = 5080;
          PROTOCOL = "http";
          ROOT_URL = "https://git.${homelab.domain}";
          LANDING_PAGE = "explore";
        };
        oauth2_client.ENABLE_AUTO_REGISTRATION=true;
        service = {
          DISABLE_REGISTRATION = true;
          ENABLE_OPENID_SIGNIN = false;
          ENABLE_OPENID_SIGNUP = false;
          ENABLE_INTERNAL_SIGNIN = true; 
          SHOW_REGISTRATION_BUTTON = false;
          ALLOW_ONLY_EXTERNAL_REGISTRATION = true;
          ALLOW_ONLY_INTERNAL_REGISTRATION = false;
          REQUIRE_EXTERNAL_REGISTRATION_PASSWORD = true;
        };
        user.ENABLE_FOLLOWING = false;
        repository = {
          DISABLE_STARS = true;
          DISABLE_FORKS = true;
          ENABLE_PUSH_CREATE_USER = true;
        };
      };
    };
    gitea-actions-runner.instances.nixos-deploy = {
      enable = true;
      name = "nixos-server-runner";
      url = "https://git.proxy.${homelab.domain}";
      tokenFile = "/mnt/data/forgejo/runner/nixos_deploy_runner_token"; 
      labels = [ "nixos-server" ];
      hostPackages = with pkgs; [ bash coreutils git nix ];
    };
  };
}
