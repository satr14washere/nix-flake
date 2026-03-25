{ git, hostname, flake-path, zsh-theme, ... }: {
  programs = {
    pay-respects = {
      enable = true;
      enableZshIntegration = true;
      options = [
        "--alias"
        "f"
      ];
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    zsh = {
      enable = true;
      autocd = true;
      syntaxHighlighting.enable = true;
      envExtra = ''
        export NIXPKGS_ALLOW_UNFREE=1
        export NIXPKGS_ALLOW_INSECURE=1
        export NH_FLAKE=${flake-path}
        export WINEPREFIX="~/.wine"
        export WINEARCH="win64"
        export DISPLAY=":0"
        export EDITOR="nvim"
        export PORT="3000"
      '';
      shellAliases = {
        "cd-gvfs" = "cd /run/user/$(id -u)/gvfs";
        "wlp-set" = "swww img --transition-type=grow --transition-duration=1";
        "ssh" = "TERM=xterm-256color ssh";
        "cd" = "z";

        "sys" = "sudo systemctl --runtime";
        "sys-log" = "journalctl -f -b -u";
        "user" = "systemctl --user --runtime";
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
        "nixos-diff" = "nix build .#nixosConfigurations.$(hostname).config.system.build.toplevel -o /tmp/nix-flake-diff && nvd diff /run/current-system /tmp/nix-flake-diff";
        "cd-conf" = "cd ${flake-path}";
        "code-conf" = "zeditor ${flake-path}";

        "mkdistro" = "distrobox create -Y -i";
        "mkdistro-arch" = "mkdistro archlinux -n arch";
        "mkdistro-deb" = "mkdistro debian -n deb";
        "wm-ctl" = "hyprctl --instance 0";
        "wm-lock" = "wm-ctl dispatch exec loginctl lock-session && notify-send ${hostname} 'Manual lock triggered'";
        "wm-disp" = "wm-ctl dispatch dpms";

        "gh-author-setup" = "git config user.name $(gh api -H \"Accept: application/vnd.github+json\" -H \"X-GitHub-Api-Version: 2022-11-28\" /user | jq -r .login) && git config user.email $(gh api -H \"Accept: application/vnd.github+json\" -H \"X-GitHub-Api-Version: 2022-11-28\" /user/emails | jq -r \".[1].email\")";
        "fg-create-repo" = "git remote add origin ${git.server}/${git.username}/$(basename $PWDw).git && git push";
        "convert-pdf" = "libreoffice --headless --convert-to pdf";
        
        "mcl" = "portablemc start -l $(cat ~/.minecraft/portablemc-launch-params.json | jq -r .email) $(cat ~/.minecraft/portablemc-launch-params.json | jq -r .version)";
        "mc" = "ferium upgrade; mcl";
      };
      initContent = ''
        export SUDO_PROMPT="Password:"
        if [[ -z "$SSH_CONNECTION" && $(tput cols) -ge 64 && $(tput lines) -ge 16 ]]; then
          # ~/.fetch.sh -c 2> /dev/null
        fi
      '';
      oh-my-zsh = {
        enable = true;
        plugins = ["git"];
        theme = if zsh-theme != "" then zsh-theme else "random";
      };
    };
  };
}
