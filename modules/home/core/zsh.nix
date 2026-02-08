{ hostname, flake-path, mc, ... }: {
  programs = {
    pay-respects = {
      enable = true;
      enableZshIntegration = true;
      options = [
        "--alias"
        "f"
      ];
    };
    zsh = {
      enable = true;
      autocd = true;
      syntaxHighlighting.enable = true;
      envExtra = ''
        NIXPKGS_ALLOW_UNFREE=1
        WINEPREFIX="~/.wine"
        WINEARCH="win64"
        DISPLAY=":0"
        EDITOR="nvim"
        PORT="3000"
      '';
      shellAliases = {
        "cd-gvfs" = "cd /run/user/$(id -u)/gvfs";
        "wlp-set" = "swww img --transition-type=grow --transition-duration=1";
        "ssh" = "TERM=xterm-256color ssh";

        "sys" = "sudo systemctl";
        "sys-log" = "journalctl -f -b -u";
        "user" = "systemctl --user";
        "user-log" = "journalctl -f -b --user-unit";

        "ts" = "sudo tailscale";
        "tsip" = "tailscale ip -4";
        "rmall" = "rm -rf ./* ./.*"; # scary!
        "srmall" = "sudo rm -rf ./* ./.*"; # also scary!

        "fetch-update" ="rm -f ~/.fetch.sh && wget https://raw.githubusercontent.com/SX-9/fetch.sh/master/fetch.sh -O ~/.fetch.sh && chmod +x ~/.fetch.sh";
        "fetch" = "~/.fetch.sh";

        "hm-sw" = "home-manager switch -b bak-hm --flake";
        "nix-sw" = "sudo nixos-rebuild switch --flake";
        "nix-hw-conf" = "nixos-generate-config --show-hardware-config";
        "cd-conf" = "cd ${flake-path}";
        "code-conf" = "zeditor ${flake-path}";

        "mkdistro" = "distrobox create -Y -i";
        "mkdistro-arch" = "mkdistro archlinux -n arch";
        "mkdistro-deb" = "mkdistro debian -n deb";
        "win11-compose" = "docker compose --file ~/.config/winapps/compose.yaml";
        "wm-ctl" = "hyprctl --instance 0";
        "wm-lock" = "wm-ctl dispatch exec loginctl lock-session && notify-send ${hostname} 'Manual lock triggered'";
        "wm-dpms" = "wm-ctl dispatch dpms";

        "git-author-setup" = "git config user.name $(gh api -H \"Accept: application/vnd.github+json\" -H \"X-GitHub-Api-Version: 2022-11-28\" /user | jq -r .login) && git config user.email $(gh api -H \"Accept: application/vnd.github+json\" -H \"X-GitHub-Api-Version: 2022-11-28\" /user/emails | jq -r \".[1].email\")";
        "mcl" = "portablemc start ${mc.version} -l ${mc.email}";
        "mc" = "ferium upgrade; mcl";

        "please" = "SUDO_PROMPT=\"What is the magic word? \" sudo";
        "pls" = "SUDO_PROMPT=\"What is the magic word? \" sudo";
      };
      initContent = ''
        if [[ -z "$SSH_CONNECTION" && $(tput cols) -ge 64 && $(tput lines) -ge 16 ]]; then
          # ~/.fetch.sh -c 2> /dev/null
        fi
      '';
      oh-my-zsh = {
        enable = true;
        plugins = ["git"];
        theme = "refined";
      };
    };
  };
}