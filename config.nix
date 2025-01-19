{
  config.vim = {
    # Language Servers
    languages = {
      enableLSP = true;
      enableFormat = true;
      enableTreesitter = true;
      enableExtraDiagnostics = true;

      rust.enable = true;
      python.enable = true;
      ts.enable = true;
      clang.enable = true;
      markdown.enable = true;
      go.enable = true;
      nix.enable = true;
      sql.enable = true;
      html.enable = true;
    };

    # Lsp config
    lsp = {
      formatOnSave = true; # Format code when saving
      lspkind.enable = false; # Adds vscode-like pictograms to completion menu
      lightbulb.enable = true; # Shows a lightbulb when code actions are available
      lspsaga.enable = false; # Provides enhanced LSP UI components
      trouble.enable = true; # Pretty list for diagnostics, references, etc.
      lspSignature.enable = true; # Shows function signature when typing
      lsplines.enable = true; # Shows diagnostic virtual lines
      otter-nvim.enable = true; # Enhanced markdown/quarto preview with LSP features
      nvim-docs-view.enable = true; # Shows LSP hover documentation in sidebar
    };

    debugger = {
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
      style = "mocha";
      transparent = false;
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
      vim-wakatime.enable = false; # Time tracking for coding
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

    # AI
    assistant = {
      chatgpt.enable = true;
      copilot = {
        enable = true;
        cmp.enable = true;
      };
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
    ];
  };
}
