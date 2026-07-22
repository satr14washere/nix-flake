{ pkgs, git, rice, ... }: {
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "brave";
    TERMINAL = "kitty";
  };

  home.packages = with pkgs; [ bun packwiz ];

  programs = {
    tmux = {
      enable = true;
      extraConfig = ''
        set -g set-clipboard on
        set -ag terminal-overrides ",*:Ms=\\E[52;%p1%s;%p2%s\\007"
        set -g allow-passthrough on
      '';
    };
    vim.enable = true;
    bat.enable = true;
    kitty = {
      enable = true;
      package = pkgs.kitty;
      settings = {
        font_family = rice.font;
        background_opacity = 0.8;
        background_blur = 4;
        window_padding_width = 8;
        cursor_shape = "beam";
        cursor_trail = 10;
        copy_on_select = true;
      };
      keybindings = {
        "ctrl+backspace" = "send_text all \\x17";
      };
    };
    ranger = {
      enable = true;
      aliases = {
        "sh" = "shell zsh";
        "zed" = "shell zeditor .";
        "vim" = "shell vim";
        "img" = "shell eog .";
      };
    };
    btop = {
      enable = true;
      settings = {
        update_ms = 100;
        shown_boxes = "proc cpu";
      };
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      withRuby = false;
      withPython3 = false;
      initLua = ''
        vim.opt.clipboard = "unnamedplus"
        vim.opt.termguicolors = true
        local osc52 = require("vim.ui.clipboard.osc52")
        vim.g.clipboard = {
          name = "OSC 52",
          copy  = { ["+"] = osc52.copy("+"),  ["*"] = osc52.copy("*")  },
          paste = { ["+"] = osc52.paste("+"), ["*"] = osc52.paste("*") },
        }
        require("nvim-tree").setup()
        vim.api.nvim_create_autocmd("VimEnter", {
          callback = function()
            vim.cmd("set nu rnu")
            vim.cmd.wincmd 'p'
          end,
        })
      '';
      plugins = with pkgs.vimPlugins; [
        bufferline-nvim
        nvim-web-devicons
        nvim-treesitter
        nvim-lspconfig
        telescope-file-browser-nvim
        nvim-tree-lua
        nvim-cmp
        indent-blankline-nvim
        markdown-preview-nvim
        vim-suda
      ];
    };
    gh = {
      enable = true;
      settings.editor = "nvim";
      gitCredentialHelper.enable = true;
      extensions = with pkgs; [
        gh-dash
        gh-skyline
        gh-eco
      ];
    };
    git = {
      enable = true;
      signing.format = null;
      settings = {
        push.autoSetupRemote = true;
        pull.rebase = "true";
        credential.helper = "cache --timeout=3600";
        user = {
          name = git.user;
          email = git.email;
        };
      };
    };

  };
}
