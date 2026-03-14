{ lib, pkgs, homelab, ... }: {
  security.sudo.extraRules = [{
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
      tokenFile = "/root/forgejo-token-runner"; 
      labels = [ "self-hosted:host" "docker" ];
      hostPackages = with pkgs; [ bash coreutils git nix ];
    };
  };
  systemd.services."gitea-runner-nixos-deploy".serviceConfig = {
    NoNewPrivileges = lib.mkForce false;
    RestrictSUIDSGID = lib.mkForce false;
    PrivateUsers = lib.mkForce false;
    User = lib.mkForce "root";
    ProtectSystem = lib.mkForce false;
    ProtectHome = lib.mkForce false;
  };
  systemd.services."gitea-runner-nixos-deploy".restartIfChanged = false;
}
