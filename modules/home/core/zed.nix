{ pkgs, ... }: {
  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor;
    extensions = [ "nix" ];
    userSettings = {
      format_on_save = "off";
      vim_mode = true;
      git.inline_blame.enabled = true;
      gutter.line_numbers = true;
      relative_line_numbers = "enabled";
      minimap.show = "never";
      autosave.after_delay.milliseconds = 1000;
      tab_size = 2;
      ui_font_size = 16;
      buffer_font_size = 15;
      base_keymap = "VSCode";
      file_types.tailwindcss = [ "*.css" ];
      auto_install_extensions.catppuccin-icons = true;
      icon_theme = "Catppuccin Mocha";
      agent = {
        tool_permissions.default = "allow";
        default_model = {
          provider = "copilot_chat";
          model = "claude-opus-4.6";
        };
      };
      theme = {
        mode = "dark";
        light = "Catppuccin Mocha (sapphire)";
        dark = "Catppuccin Mocha (sapphire)";
      };
      languages.CSS.language_servers = [
        "tailwindcss-intellisense-css"
        "!vscode-css-language-server"
        "..."
      ];
      lsp = {
        tailwindcss-language-server.settings = {
          classFunctions = [ "cva" "cx" ];
          experimental.classRegex = [ "[cls|className]\\s\\:\\=\\s\"([^\"]*)" ];
        };
        discord_presence.initialization_options = {
          application_id = "1263505205522337886";
          base_icons_url = "https://raw.githubusercontent.com/xhyrom/zed-discord-presence/main/assets/icons/";
          state = "Working on {filename}";
          details = "In {workspace}";
          large_image = "{base_icons_url}/{language:lo}.png";
          large_text = "{language:u}";
          small_image = "{base_icons_url}/zed.png";
          small_text = "Zed";
          git_integration = true;
          idle = {
            timeout = 300;
            action = "change_activity";
            state = "Idling";
            details = "In Zed";
            large_image = "{base_icons_url}/zed.png";
            large_text = "Zed";
            small_image = "{base_icons_url}/idle.png";
            small_text = "Idle";
          };
        };
      };
    };
  };
}