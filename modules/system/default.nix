{ pkgs, locale, ... }: {
  imports = [
    ./core/virtualization.nix
    ./core/bootloader.nix
    ./core/filesystem.nix
    ./core/network.nix
    ./core/kernel.nix
    ./core/shell.nix
    ./core/user.nix
    ./misc/programs.nix
    ./misc/graphics.nix
    ./desktop.nix
    ./base.nix
  ];

  i18n.defaultLocale = locale;
  environment.localBinInPath = true;

  security = {
    sudo.configFile = ''
      Defaults insults
      Defaults passwd_tries = 5
    '';
  };
}
