{ lib, pkgs, homelab, ... }: let
  domain = "docs.${homelab.domain}";
  sandbox = "docs-sandbox.${homelab.domain}";
in {
  services.cryptpad = {
    enable = true;
    settings = {
      websocketPort = 7091;
      httpPort = 7090;
      httpAddress = "127.0.0.1";
      httpUnsafeOrigin = "https://${domain}";
      httpSafeOrigin = "https://${sandbox}";
      blockDailyCheck = true;
      disableIntegratedEviction = true;
      adminKeys = [ 
        "[satr14@docs.satr14.my.id/f1A82fmBuqQka2bNqrCb1WbB9r2ex5A3rdys5xLX3Hc=]"
      ];
    };
  };
  
  systemd.tmpfiles.rules = lib.singleton "f /var/lib/cryptpad/customize/application_config.js 0644 root root - ${pkgs.writeText "cryptpad-application-config.js" ''
    (() => {
      const factory = (AppConfig) => {
          AppConfig.disableAnonymousPadCreation = true;
          AppConfig.disableAnonymousStore = true;
          AppConfig.defaultDarkTheme = 'true';
          return AppConfig;
      };
  
      if (typeof(module) !== 'undefined' && module.exports) {
          module.exports = factory(
              require('../www/common/application_config_internal.js')
          );
      } else if ((typeof(define) !== 'undefined' && define !== null) && (define.amd !== null)) {
          define(['/common/application_config_internal.js'], factory);
      }
    })();
  ''}";
  
  fileSystems."/var/lib/private/cryptpad" = {
    device = "/mnt/data/apps/cryptpad";
    depends = [ "/mnt/data" ]; 
    options = [ "bind" "nofail" ];
    fsType = "none";
  };
}
