{ username, ... }: {
  imports = [
    ./misc/kde-connect.nix
    ./core/apps.nix
    ./core/zed.nix
    ./core/xdg.nix
    ./core/cli.nix
    ./core/zsh.nix
  ];

  home = {
    stateVersion = "24.11";
    username = "${username}";
    homeDirectory = "/home/${username}";
  };
}
