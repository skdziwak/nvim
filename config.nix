{
  isFull,
  extraLanguages,
}: {
  lib,
  pkgs,
  ...
}: {
  config.vim = {
    # Language Servers
    languages =
      (
        if isFull
        then {
          terraform.enable = true;
          java.enable = true;
          rust.enable = true;
          ts.enable = true;
          clang.enable = true;
          go.enable = true;
          nix.enable = true;
          sql.enable = true;
          html.enable = true;
        }
        else {}
      )
      // {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;
        markdown.enable = true;
      }
      // extraLanguages;

    # Lsp config
    lsp = {
      enable = true;
      formatOnSave = true; # Format code when saving
      lspkind.enable = false; # Adds vscode-like pictograms to completion menu
      lightbulb.enable = true; # Shows a lightbulb when code actions are available
      lspsaga.enable = false; # Provides enhanced LSP UI components
      trouble.enable = true; # Pretty list for diagnostics, references, etc.
      lspSignature.enable = true; # Shows function signature when typing
      nvim-docs-view.enable = true; # Shows LSP hover documentation in sidebar
      lspconfig.sources.python-lsp = ''
        lspconfig.basedpyright.setup {
          capabilities = capabilities;
          on_attach = default_on_attach;
          settings = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = false,
              typeCheckingMode = "off"
            }
          };
          cmd = { "${pkgs.basedpyright}/bin/basedpyright-langserver", "--stdio" };
        }
      '';
    };

    debugger = lib.mkIf isFull {
      nvim-dap = {
        enable = true; # Debug Adapter Protocol support
        ui.enable = true; # UI for debug sessions
      };
    };

    # Options
    options = {
      shiftwidth = 4;
      expandtab = true;
      smarttab = true;
      autoindent = true;
      smartindent = true;
      backspace = "indent,eol,start";
      clipboard = "unnamedplus";
      mouse = "a";
      laststatus = 2;
      showtabline = 2;
      wildmenu = true;
      lazyredraw = false;
      scrolloff = 8;
      sidescrolloff = 8;
      hlsearch = true;
      ignorecase = true;
      smartcase = true;
      incsearch = true;
      showcmd = true;
      showmode = true;
      backup = false; # Disable backup files
      writebackup = false; # Disable backup files during writing
      swapfile = false; # Disable swap files
      autoread = true; # Automatically read files when changed
    };

    # Statusline
    statusline = {
      lualine = {
        enable = true;
        theme = "catppuccin";
      };
    };

    # Theme
    theme = {
      enable = true;
      name = "catppuccin";
      style = "frappe";
      transparent = true;
    };

    # Visuals
    visuals = {
      nvim-scrollbar.enable = true;
      nvim-web-devicons.enable = true;
      nvim-cursorline.enable = true;
      cinnamon-nvim.enable = true;
      fidget-nvim.enable = true;

      highlight-undo.enable = true;
      indent-blankline.enable = true;
    };

    autopairs.nvim-autopairs.enable = true; # Auto-close brackets, quotes, etc.
    autocomplete.nvim-cmp.enable = true; # Code completion engine
    snippets.luasnip.enable = true; # Snippet engine

    filetree.neo-tree.enable = true; # File explorer sidebar
    tabline.nvimBufferline.enable = true; # Buffer/tab line at top of editor
    treesitter.context.enable = true; # Shows code context while scrolling

    binds.whichKey.enable = true; # Key binding helper popup
    binds.cheatsheet.enable = true; # Shows available keybindings

    telescope.enable = true; # Fuzzy finder for files, grep, etc.

    git = {
      enable = true; # Git integration
      gitsigns.enable = true; # Shows git changes in sign column
      gitsigns.codeActions.enable = false; # Git actions in code
    };

    dashboard.dashboard-nvim.enable = false; # Start screen dashboard
    dashboard.alpha.enable = true; # Alternative start screen

    notify.nvim-notify.enable = true; # Notification manager

    utility = {
      ccc.enable = false; # Color picker and highlighter
      icon-picker.enable = true; # Unicode icon/emoji picker
      surround.enable = true; # Easy text surrounds manipulation
      diffview-nvim.enable = true; # Git diff viewer
      motion = {
        hop.enable = true; # Quick jump to any text position
        leap.enable = true; # Quick motion/jump plugin
        precognition.enable = false; # Shows preview of motion commands
      };
      images = {
        image-nvim.enable = false; # View images in neovim
      };
    };

    ui = {
      borders.enable = true; # Adds borders to floating windows
      noice.enable = true; # Replaces UI for cmdline, messages, etc.
      colorizer.enable = true; # Highlights color codes with their color
      modes-nvim.enable = true; # Changes cursor color based on mode
      illuminate.enable = true; # Highlights other uses of word under cursor
      breadcrumbs = {
        enable = true; # Shows code context in winbar
        navbuddy.enable = true; # Code navigation sidebar
      };
    };

    comments.comment-nvim.enable = true; # Easy code commenting

    # Extra plugins
    extraPlugins = with pkgs.vimPlugins; {
      nerdtree = {
        package = nerdtree;
        setup = ''
          vim.api.nvim_set_keymap("n", "<leader>e", ":NERDTreeToggle<CR>", { noremap = true, silent = true })
        '';
      };
      copilot = {
        package = copilot-vim;
        setup = ''

          vim.api.nvim_set_keymap('i', '<C-a>', "", { noremap = true, silent = true })
          vim.keymap.set('i', '<C-a>', 'copilot#Accept("\\<CR>")', {
            expr = true,
            replace_keycodes = false
          })
          vim.g.copilot_no_tab_map = true
        '';
      };
      copilot-chat = lib.mkIf isFull {
        package = CopilotChat-nvim;
        setup = ''
          require("CopilotChat").setup {
            prompts = {
              Full = {
                prompt = "> You rewrite whole files in code blocks without line numbers."
              }
            },
            model = "claude-3.7-sonnet-thought"
          }
        '';
      };
    };
    luaConfigRC = {
      indentation = ''
        -- Keep selection after indenting
        vim.api.nvim_set_keymap("v", "<", "<gv", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("v", ">", ">gv", { noremap = true, silent = true })

      '';
      auto-reload = ''
        -- Auto reload on file change
        vim.api.nvim_create_augroup("AutoReload", { clear = true })
        vim.api.nvim_create_autocmd({"BufEnter", "FocusGained", "BufWritePost"}, {
          group = "AutoReload",
          pattern = "*",
          command = "checktime",
          nested = true
        })
      '';
      globals = ''
        local function get_comment_prefix()
          local comment_string = vim.bo.commentstring
          local comment_prefix

          if comment_string and #comment_string > 0 then
            local s_pos = string.find(comment_string, "%%s")
            if s_pos then
              comment_prefix = string.sub(comment_string, 1, s_pos - 1)
              comment_prefix = comment_prefix:gsub("%s*$", "") -- Trim trailing spaces from prefix
            else
              comment_prefix = comment_string -- Use as is (e.g., for "--" in SQL/Lua, or "REM" if no %s)
            end
          else
            comment_prefix = "//" -- Default if commentstring is not set or empty
          end

          -- If after processing, comment_prefix is empty (e.g., commentstring was just "%s"), use default
          if not comment_prefix or #comment_prefix == 0 then
            comment_prefix = "//"
          end
          return comment_prefix
        end

        local function prompt_for_ai_text()
          return vim.fn.input("Enter text for AI comment: ")
        end

        function _G.AddAiCommentAndSaveAll()
          local comment_prefix = get_comment_prefix()
          local user_input = prompt_for_ai_text()

          -- If user cancels or enters empty string, do nothing
          if user_input == nil or user_input == "" then
            return
          end

          -- Construct the final text
          local final_text = comment_prefix .. " " .. user_input .. " AI!"

          -- Navigate to the end of the current line
          vim.cmd('normal! $')

          -- Insert the text as a new line after the current line
          vim.api.nvim_put({final_text}, 'l', true, true)

          -- Save all buffers
          vim.cmd('wa')
        end
        vim.keymap.set('n', '<leader>aw', function() _G.AddAiCommentAndSaveAll() end, { noremap = true, silent = true, desc = "Add AI comment and save all" })
      '';
    };

    # Keymaps
    keymaps = [
      {
        key = "jj";
        action = "<Esc>";
        mode = ["i"];
        silent = true;
        desc = "Escape insert mode";
      }
      {
        key = "<leader>y";
        desc = "Copy a code block";
        mode = "n";
        silent = true;
        action = "?```<CR>jV/```<CR>ky<C-o>";
      }
      {
        key = "<leader>gr";
        action = ":Gitsigns reset_hunk<CR>";
        mode = ["n"];
        silent = true;
        desc = "Reset git hunk";
      }
      {
        key = "<leader>r";
        desc = "Replace contents of this whole buffer with the contents of the clipboard";
        mode = "n";
        silent = true;
        action = ":%d<CR>\"+p";
      }
    ];
  };
}
