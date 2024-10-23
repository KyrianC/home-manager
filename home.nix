{ config, pkgs, lib, inputs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "kyrian";
  home.homeDirectory = "/home/${home.username}";

  imports = [ inputs.nixvim.homeManagerModules.nixvim ];

  nix.gc = {
    automatic = true;
    frequency = "weekly";
  };

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    extraConfigLua = ''
      vim.opt.fillchars:append { diff = "╱" }

      vim.api.nvim_set_option("clipboard", "unnamedplus") -- copy to & from system clipboard

      for name, icon in pairs({ Error = "󰅙", Info = "󰋼", Hint = "󰌵", Warn = "" }) do
        local hl = "DiagnosticSign" .. name
        vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
      end
    '';

    diagnostics = {
      virtual_lines = { only_current_line = true; };
      virtual_text = false;
    };

    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavor = "mocha";
        integrations = {
          cmp = true;
          gitsigns = true;
          treesitter = true;
          telescope = { enabled = true; };
        };
      };
    };

    opts = {
      number = true;
      relativenumber = true;
      mouse = "a";
      ignorecase = true;
      smartcase = true;
      hlsearch = false;
      wrap = false;
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      termguicolors = true;
      signcolumn = "yes";
      foldmethod = "manual";
    };

    globals = { mapleader = " "; };

    keymaps = [
      {
        key = "<tab>";
        action = "%";
        mode = [ "n" "v" "s" "o" ];
        options = {
          silent = true;
          noremap = true;
        };
      }
      {
        key = "jk";
        action = "<esc>";
        mode = "i";
        options = { silent = true; };
      }
      {
        key = "kj";
        action = "<esc>";
        mode = "i";
        options = { silent = true; };
      }
      {
        key = "<leader>dd";
        action = "<cmd>lua vim.diagnostic.open_float()<cr>";
      }
      {
        key = "<leader>dp";
        action = "<cmd>lua vim.diagnostic.goto_prev()<cr>";
      }
      {
        key = "<leader>dn";
        action = "<cmd>lua vim.diagnostic.goto_next()<cr>";
      }
      {
        key = "<leader>dq";
        action = "<cmd>lua vim.diagnostic.setloclist()<cr>";
      }
      {
        key = "<leader>w";
        action = "<C-w>";
      }
      {
        key = "<leader>gg";
        action = "<cmd>Neogit<cr>";
      }
      {
        key = "<leader>bb";
        action = "<cmd>lua require('telescope.builtin').buffers()<cr>";
      }
      {
        key = "<leader>bp";
        action = "<cmd>bp<cr>";
      }
      {
        key = "<leader>bn";
        action = "<cmd>bn<cr>";
      }
      {
        key = "<leader>bd";
        action = "<cmd>bd<cr>";
      }
      {
        key = "<leader>bD";
        action = "<cmd>%bd<cr>";
      }
      {
        key = "<leader>ss";
        action = ''
          <cmd>lua require("telescope.builtin").current_buffer_fuzzy_find()<cr>'';
      }
      {
        key = "<leader>sp";
        action = ''<cmd>lua require("telescope.builtin").live_grep()<cr>'';
      }
      {
        key = "<leader><leader>";
        action = ''<cmd>lua require("telescope.builtin").find_files()<cr>'';
      }
      {
        key = "<leader>fs";
        action = "<cmd>write<cr>";
      }
      {
        key = "<leader>ff";
        action = "<cmd>Oil<cr>";
      }
      {
        key = "<leader>ca";
        action = "<cmd>lua vim.lsp.buf.code_action()<cr>";
      }
      {
        key = "<leader>cr";
        action = "<cmd>lua vim.lsp.buf.rename()<cr>";
      }
      {
        key = "<leader>gl";
        action = ''
          <cmd>lua require("neogit").action("log", "log_current", { "--", vim.fn.expand("%") })()<cr>'';
      }
      {
        key = "<leader>gh";
        action = "<cmd>DiffviewFileHistory %<cr>";
      }
      {
        key = "gD";
        action = ''<cmd>lua require("telescope.builtin").lsp_references()<cr>'';
      }
      {
        key = "gd";
        action = "<cmd>lua vim.lsp.buf.definition()<cr>";
      }
      {
        key = "K";
        action = "<cmd>lua vim.lsp.buf.hover()<cr>";
      }
    ];

    plugins = {

      cmp = {
        enable = true;
        cmdline = {
          "/" = {
            sources = [{ name = "buffer"; }];
            mapping = { __raw = "cmp.mapping.preset.cmdline()"; };
          };
          "?" = {
            sources = [{ name = "buffer"; }];
            mapping = { __raw = "cmp.mapping.preset.cmdline()"; };
          };
          ":" = {
            sources = [ { name = "path"; } { name = "cmdline"; } ];
            mapping = { __raw = "cmp.mapping.preset.cmdline()"; };
          };
        };
        filetype = {
          gitcommit = {
            sources = [
              { name = "git"; }
              { name = "buffer"; }
              { name = "conventionalcommits"; }
            ];
          };
        };
        settings = {
          snippet = {
            expand =
              "function(args) require('luasnip').lsp_expand(args.body) end";
          };
          mapping = {
            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.abort()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<C-j>" = "cmp.mapping.select_next_item()";
            "<C-k>" = "cmp.mapping.select_prev_item()";
            "<C-n>" = "cmp.mapping.select_next_item()";
            "<C-p>" = "cmp.mapping.select_prev_item()";
          };
          sources = [
            { name = "nvim_lsp"; }
            { name = "nvim_lsp_signature_help"; }
            { name = "path"; }
            { name = "buffer"; }
            { name = "cmdline"; }
            { name = "git"; }
          ];
        };
      };
      cmp-buffer.enable = true;
      cmp-cmdline.enable = true;
      cmp-path.enable = true;
      cmp-git.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-nvim-lsp-signature-help.enable = true;
      cmp_luasnip.enable = true;
      cmp-conventionalcommits.enable = true;

      # generate doc string for multiple languages
      neogen = {
        enable = true;
        snippetEngine = "luasnip";
      };

      avante = { enable = true; };

      # formatter
      conform-nvim = {
        enable = true;
        # TODO: add keymap <leader>cf to format buffer or selected region

        settings = {
          format_on_save = {
            timeoutMs = 500;
            lspFallback = true;
          };

          formatters = {
            black = { command = "${lib.getExe pkgs.black}"; };
            isort = { command = "${lib.getExe pkgs.isort}"; };
            prettierd = { command = "${lib.getExe pkgs.prettierd}"; };
            nixfmt = { command = "${lib.getExe pkgs.nixfmt}"; };
          };

          formatters_by_ft = {
            python = [ "isort" "black" ];
            javascript = [ "prettierd" ];
            javascriptreact = [ "prettierd" ];
            typescript = [ "prettierd" ];
            typescriptreact = [ "prettierd" ];
            json = [ "prettierd" ];
            html = [ "prettierd" ];
            css = [ "prettierd" ];
            vue = [ "prettierd" ];
            svelte = [ "prettierd" ];
            nix = [ "nixfmt" ];
          };
        };

      };

      telescope = { enable = true; };

      treesitter = {
        enable = true;
        folding = false;
        nixvimInjections = true;
        settings = {
          highlight = { enable = true; };
          indent = { enable = true; };
        };
      };

      otter = { enable = true; };

      comment = { enable = true; };

      neogit = {
        enable = true;
        settings = { graph_style = "unicode"; };
      };

      oil = {
        enable = true;
        settings = {
          # columns = [ "icon" "permissions" "size" "mtime" ];
          skip_confirm_for_simple_edits = true;
          view_options.show_hidden = true;
        };
      };

      tmux-navigator = {
        enable = true;
        keymaps = [
          {
            action = "left";
            key = "<M-h>";
          }
          {
            action = "down";
            key = "<M-j>";
          }
          {
            action = "up";
            key = "<M-k>";
          }
          {
            action = "right";
            key = "<M-l>";
          }
          {
            action = "previous";
            key = "<leader>ww";
          }
        ];
        settings = { no_mappings = 1; };
      };

      lsp = {
        enable = true;
        servers = {
          pyright = { enable = true; };
          yamlls = { enable = true; };
          lua-ls = { enable = true; };
          svelte = { enable = true; };
          gopls = { enable = true; };
          ts-ls = {
            enable = true;
            filetypes = [
              "typescript"
              "javascript"
              "javascriptreact"
              "typescriptreact"
              "vue"
              "svelte"
            ];
            # extraOptions = {
            #   init_options = {
            #     plugins = [{
            #       name = "@vue/typescript-plugin";
            #       location = "${
            #           lib.getBin pkgs.vue-language-server
            #         }/lib/node_modules/@vue/language-server";
            #       languages = [ "vue" ];
            #     }];
            #   };
            # };
          };
          volar = {
            enable = true;
            # package = pkgs.vue-language-server;
            filetypes = [
              "typescript"
              "javascript"
              "javascriptreact"
              "typescriptreact"
              "vue"
              "json"
            ];
          };
          cssls = { enable = true; };
          tailwindcss = { enable = true; };
          eslint = { enable = true; };
          docker-compose-language-service = { enable = true; };
          emmet-ls = { enable = true; };
        };
      };

      web-devicons = { enable = true; };

      mini = {
        enable = true;
        modules = {
          animate = {
            cursor = { enable = false; };
            scroll = { enable = true; };
          };
        };
      };

      lualine = {
        enable = true;
        settings = {
          options = {
            theme = "catppuccin";
            component_separators = {
              left = " ";
              right = " ";
            };
            section_separators = {
              left = "";
              right = "";
            };
          };
        };
      };

      diffview = { enable = true; };

      luasnip = { enable = true; };

      leap = { enable = true; };

      git-conflict = { enable = true; };

      gitsigns = { enable = true; };

    };
  };

  programs.git = {
    enable = true;
    userName = "KyrianC";
    userEmail = "ckyrian@protonmail.com";
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = { aws = { disabled = true; }; };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    defaultKeymap = "viins";
    syntaxHighlighting = {
      enable = true;
      highlighters = [ "main" "brackets" ];
    };
    dirHashes = {
      docs = "$HOME/Documents";
      dl = "$HOME/Downloads";
      prj = "$HOME/Projects/";
    };
    shellAliases = {
      ll = "ls -lah";
      ".." = "cd ..";
    };
  };

  programs.tmux = {
    enable = true;
    shell = "${lib.getExe pkgs.zsh}";
    terminal = "screen-256color";
    tmuxinator.enable = true;
    keyMode = "vi";
    mouse = true;
    prefix = "C-Space";
    historyLimit = 9000;
    plugins = [
      {
        plugin = pkgs.tmuxPlugins.vim-tmux-navigator;
        extraConfig = ''
          is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
              | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
          unbind 'C-l'
          bind-key -n 'M-h' if-shell "$is_vim" 'send-keys M-h' 'select-pane -L'
          bind-key -n 'M-j' if-shell "$is_vim" 'send-keys M-j' 'select-pane -D'
          bind-key -n 'M-k' if-shell "$is_vim" 'send-keys M-k' 'select-pane -U'
          bind-key -n 'M-l' if-shell "$is_vim" 'send-keys M-l' 'select-pane -R'
          bind-key -n 'M-p' if-shell "$is_vim" 'send-keys M-p' 'select-pane -l'
        '';
      }
      {
        plugin = pkgs.tmuxPlugins.catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour 'mocha'
          set -g @catppuccin_window_current_text "#W"
          set -g @catppuccin_window_default_text "#W"
          set -g @catppuccin_window_left_separator ""
          set -g @catppuccin_window_right_separator " "
          set -g @catppuccin_window_middle_separator "█ "
          set -g @catppuccin_window_number_position "left"
        '';
      }
      {
        plugin = pkgs.tmuxPlugins.yank;
        extraConfig = ''
          set -g @yank_selection_mouse 'clipboard'
        '';
      }
    ];
    extraConfig = ''
      set -sa terminal-features ",xterm-256color:RGB"
      set-option -sa terminal-features ',alacritty:RGB' # Makes sure that colors in tmux are the same as without tmux
      set-option -ga terminal-features ",alacritty:usstyle"
      bind C-space choose-session
      bind s split-window -c "#{pane_current_path}"
      bind v split-window -h -c "#{pane_current_path}"
      bind-key -n 'M-0' 'select-window -t 9'
      bind-key -n 'M-1' 'select-window -t 0'
      bind-key -n 'M-2' 'select-window -t 1'
      bind-key -n 'M-3' 'select-window -t 2'
      bind-key -n 'M-4' 'select-window -t 3'
      bind-key -n 'M-5' 'select-window -t 4'
      bind-key -n 'M-6' 'select-window -t 5'
      bind-key -n 'M-7' 'select-window -t 6'
      bind-key -n 'M-8' 'select-window -t 7'
      bind-key -n 'M-9' 'select-window -t 8'
      set-option -g status-position top
      set -g mouse on
    '';
  };

  programs.firefox = {
    enable = true;
    enableGnomeExtensions = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.gnome-shell = {
    enable = true;
    extensions = [{ package = pkgs.gnomeExtensions.gsconnect; }];
  };

  programs.bat = { enable = true; };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.zap
    pkgs.ffuf
    pkgs.seclists

    pkgs.ripgrep
    pkgs.glibc
    pkgs.gcc

    pkgs.python3
    pkgs.nodejs_22
    pkgs.go

    pkgs.nixgl.nixGLIntel

    pkgs.isort
    pkgs.black
    pkgs.prettierd
    pkgs.nixfmt

    pkgs.zrok

    # smooth-cursor fork of alacritty
    (pkgs.alacritty.overrideAttrs (old: rec {
      src = pkgs.fetchFromGitHub {
        owner = "KyrianC";
        repo = "alacritty-smooth-cursor";
        rev = "e2e8f9e5172435f34978ec5ca57f51a701166518";
        hash = "sha256-6HctsYZUsadGrRrh68/t9tx5cGxdOSph0t4C/6FaWUQ=";
      };

      cargoDeps = old.cargoDeps.overrideAttrs (lib.const {
        name = "alacritty-smooth-cursor-vendor.tar.gz";
        inherit src;
        outputHash = "sha256-OIn8JJxlnQJ3FmWgU+At2br/IIvIPG8zQGgVXsdVXD4=";
      });

      # wayland support
      postInstall = old.postInstall + ''
        wrapProgram $out/bin/alacritty --unset WAYLAND_DISPLAY
      '';
    }))

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/nixos/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = { EDITOR = "nvim"; };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
