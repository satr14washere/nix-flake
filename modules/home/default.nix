{ username, ... }: {
  imports = [
    ./rice/theme.nix
    ./core/shell.nix
    ./core/cli.nix
  ];

  home = {
    stateVersion = "24.11";
    username = "${username}";
    homeDirectory = "/home/${username}";
  };
}
