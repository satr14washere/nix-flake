{ username, ... }: {
  imports = [
    ./core/shell.nix
    ./core/cli.nix
  ];

  home = {
    stateVersion = "24.11";
    username = "${username}";
    homeDirectory = "/home/${username}";
  };
}
