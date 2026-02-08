{ pkgs, git, rice, ... }: {
  programs = {
    tmux.enable = true;
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
      initLua = ''
        vim.opt.clipboard = "unnamedplus"
        vim.opt.termguicolors = true
        require("nvim-tree").setup()
        vim.api.nvim_create_autocmd("VimEnter", {
          callback = function()
            -- vim.cmd("NvimTreeOpen")
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
        barbar-nvim
        indent-blankline-nvim
        markdown-preview-nvim
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
      settings = {
        pull.rebase = "true";
        user = {
          name = git.user;
          email = git.email;
        };
      };
    };

  };
}