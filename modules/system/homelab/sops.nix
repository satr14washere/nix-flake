{ config, ... }: {
  sops = {
    defaultSopsFile = ../../../secrets/homelab.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets = {
      cloudflare_dns_api_token = {
        owner = "acme";
        group = "acme";
      };

      cloudflared_tunnel_credentials = {
        owner = "cloudflared";
        group = "cloudflared";
      };

      cloudflared_cert = {
        owner = "cloudflared";
        group = "cloudflared";
      };

      vaultwarden_env = {
        owner = "vaultwarden";
        group = "vaultwarden";
        restartUnits = [ "vaultwarden.service" ];
      };

      glance_env = {
        owner = "glance";
        group = "glance";
        restartUnits = [ "glance.service" ];
      };

      pocketid_encryption_key = {
        owner = "root";
        group = "root";
        restartUnits = [ "pocket-id.service" ];
      };

      tailscale_authkey = {
        owner = "root";
        group = "root";
        restartUnits = [ "tailscaled.service" ];
      };

      nginx_htpasswd = {
        owner = "nginx";
        group = "nginx";
        restartUnits = [ "nginx.service" ];
      };
    };

    templates."cloudflare.env" = {
      owner = "acme";
      group = "acme";
      content = "CLOUDFLARE_DNS_API_TOKEN=${config.sops.placeholder.cloudflare_dns_api_token}";
    };
  };
}