-- ============================================================================
-- NEOVIM CONFIGURATION
-- ============================================================================
-- Single-file config with extensive comments for easy navigation and tweaking
-- Key bindings use <space> as the leader key (press space, then another key)
--
-- Quick reference:
--   <space>e     - Toggle file tree
--   <space>ff    - Find files (fuzzy search)
--   <space>fg    - Find in files (grep)
--   <space>fb    - Find buffers
--   <space>gb    - Toggle git blame
--   Ctrl+P       - Find files (VSCode-style)
--   Tab          - Accept completion
--   Ctrl+Space   - Trigger completion manually
-- ============================================================================

-- ============================================================================
-- BASIC EDITOR SETTINGS
-- ============================================================================

-- Set leader key to space (press space before custom shortcuts)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Line numbers
vim.opt.number = true           -- Show line numbers
vim.opt.relativenumber = true   -- Show relative line numbers (easier for motions like 5j)

-- Indentation
vim.opt.tabstop = 2             -- Number of spaces tabs count for
vim.opt.shiftwidth = 2          -- Size of an indent
vim.opt.expandtab = true        -- Use spaces instead of tabs
vim.opt.smartindent = true      -- Insert indents automatically

-- Search
vim.opt.ignorecase = true       -- Ignore case when searching
vim.opt.smartcase = true        -- Don't ignore case if search has uppercase
vim.opt.hlsearch = true         -- Highlight search results
vim.opt.incsearch = true        -- Show search matches as you type

-- UI
vim.opt.termguicolors = false   -- Use the terminal's own ANSI palette/theme instead of hardcoded RGB
vim.opt.cursorline = true       -- Highlight current line
vim.opt.signcolumn = 'yes'      -- Always show sign column (for git/lsp signs)
vim.opt.scrolloff = 8           -- Keep 8 lines above/below cursor
vim.opt.wrap = false            -- Don't wrap lines

-- Splits
vim.opt.splitright = true       -- Vertical splits go to the right
vim.opt.splitbelow = true       -- Horizontal splits go below

-- Other
vim.opt.mouse = 'a'             -- Enable mouse support
vim.opt.clipboard = 'unnamedplus' -- Use system clipboard
vim.opt.undofile = true         -- Save undo history
vim.opt.updatetime = 250        -- Faster completion and updates
vim.opt.timeoutlen = 300        -- Time to wait for key sequences

-- ============================================================================
-- SYNTAX HIGHLIGHTING (inspired by the "Navy and Ivory" VS Code theme)
-- https://github.com/vanev/navy-and-ivory
-- ============================================================================
-- With termguicolors off, treesitter captures are mapped to the terminal's
-- own 16 ANSI slots (ctermfg 0-15) rather than fixed hex, so this only looks
-- right if the terminal profile's ANSI palette is actually set to
-- Navy and Ivory's `terminal.ansi*` colors:
--
--   0 black  #102c33   1 red     #b34f52   2 green   #8cbca1   3 yellow  #887a67
--   4 blue   #65778b   5 magenta #e7657d   6 cyan    #67b3b0   7 white   #f2f0c2
--   8 br.black #2b5e70  9 br.red #dc6253  10 br.green #aed6b5  11 br.yellow #bcb096
--  12 br.blue #9bb7d6  13 br.magenta #ee9fa4  14 br.cyan #abd7d6  15 br.white #f6f4cf
--
-- Slot choice per group mirrors the theme's own tokenColors scopes (blue-gray
-- for keywords/structure, cyan for functions, bright cyan for types/classes,
-- green for strings, magenta for numbers, tan for escapes/regexp). Two of the
-- theme's syntax colors - the decorator coral (#D08770) and the preprocessor
-- "nord blue" (#5E81AC) - aren't in its 16-slot terminal palette at all, so
-- those are approximated to the nearest otherwise-unused slot (bright red,
-- bright blue) rather than left to invent an unrelated color.
-- Both legacy and current treesitter capture names are set below, since
-- which one applies depends on the query shipped for a given language.
local syntax_groups = {
  -- Comments (theme: "Comment" #616E88, close kin of the keyword blue-gray;
  -- italic is our own addition, common convention the theme leaves to editor config)
  ['@comment']               = { ctermfg = 4, italic = true },
  ['@comment.documentation']  = { ctermfg = 4, italic = true },

  -- Literals
  ['@string']           = { ctermfg = 2 }, -- "String" #8cbca1
  ['@character']        = { ctermfg = 2 }, -- "Constant Character" reuses string green here
  ['@string.escape']    = { ctermfg = 3 }, -- "Constant Character Escape" #887a67
  ['@string.regexp']    = { ctermfg = 3 }, -- "String Regexp" #887a67
  ['@string.special']   = { ctermfg = 15 }, -- template-literal interpolation punctuation #f6f4cf
  ['@number']           = { ctermfg = 5 }, -- "Constant Numeric" #e7657d
  ['@number.float']     = { ctermfg = 5 },
  ['@boolean']          = { ctermfg = 10, bold = true }, -- liberty: distinct from plain constants
  ['@constant']         = { ctermfg = 4 }, -- "Constant Language" #65778b
  ['@constant.builtin'] = { ctermfg = 4, bold = true },
  ['@constant.macro']   = { ctermfg = 11 }, -- liberty: distinct from @string.escape's tan

  -- Keywords - theme keeps these an understated blue-gray, not bold
  ['@keyword']              = { ctermfg = 4 },
  ['@keyword.function']     = { ctermfg = 4 },
  ['@keyword.return']       = { ctermfg = 4 },
  ['@keyword.import']       = { ctermfg = 4 },
  ['@keyword.conditional']  = { ctermfg = 4 },
  ['@keyword.repeat']       = { ctermfg = 4 },
  ['@keyword.operator']     = { ctermfg = 4 },
  ['@conditional']          = { ctermfg = 4 }, -- legacy name
  ['@repeat']               = { ctermfg = 4 }, -- legacy name

  -- Functions ("Entity Name Function" / "Support Function" both #67b3b0)
  ['@function']              = { ctermfg = 6 },
  ['@function.call']         = { ctermfg = 6 },
  ['@function.builtin']      = { ctermfg = 6 },
  ['@function.macro']        = { ctermfg = 4 }, -- "Support Function Construct" #65778b
  ['@function.method']       = { ctermfg = 6 },
  ['@function.method.call']  = { ctermfg = 6 },
  ['@method']                = { ctermfg = 6 }, -- legacy name
  ['@method.call']           = { ctermfg = 6 }, -- legacy name
  ['@constructor']           = { ctermfg = 14 },

  -- Types - theme splits general types/classes (bright cyan) from builtin
  -- primitives (plain blue, "Storage Type Primitive")
  ['@type']         = { ctermfg = 14 },
  ['@type.builtin'] = { ctermfg = 4 },

  -- Variables ("Variable"/"Variable Parameter" are literally just fg #e7e0d7,
  -- so they're left unset here to inherit the normal foreground)
  ['@variable.builtin'] = { ctermfg = 4, italic = true }, -- "Variable Language" #65778b
  ['@variable.member']  = { ctermfg = 6 }, -- JS object-literal key #67b3b0
  ['@property']         = { ctermfg = 6 }, -- legacy name
  ['@field']            = { ctermfg = 6 }, -- legacy name

  -- Punctuation / operators ("Punctuation" #f6f4cf)
  ['@operator']               = { ctermfg = 15 },
  ['@punctuation.delimiter']  = { ctermfg = 15 },
  ['@punctuation.bracket']    = { ctermfg = 15 },
  ['@punctuation.special']    = { ctermfg = 15 },

  -- Modules / misc ("Storage Modifier Package" / C include path #abd7d6)
  ['@module']    = { ctermfg = 14 },
  ['@namespace'] = { ctermfg = 14 }, -- legacy name
  ['@label']     = { ctermfg = 4 },
  ['@attribute'] = { ctermfg = 9 }, -- decorators; approximated coral, see note above

  -- Preprocessor directives (#define/#include/#ifdef, C/CPP conditional
  -- directives, XML/HTML doctypes) - approximated "nord blue", see note above
  ['@keyword.directive']        = { ctermfg = 12, bold = true },
  ['@keyword.directive.define'] = { ctermfg = 12, bold = true },
  ['@preproc']                  = { ctermfg = 12, bold = true }, -- legacy name

  -- Markup tags (JSX/HTML)
  ['@tag']           = { ctermfg = 4 }, -- "Entity Name Tag" #65778b
  ['@tag.attribute'] = { ctermfg = 14 }, -- "Entity Other Attribute Name" #abd7d6
  ['@tag.delimiter'] = { ctermfg = 4 }, -- "Punctuation Definition Tag" #65778b
}

for group, opts in pairs(syntax_groups) do
  vim.api.nvim_set_hl(0, group, opts)
end

-- ============================================================================
-- PLUGIN MANAGER SETUP (lazy.nvim)
-- ============================================================================
-- Bootstrap lazy.nvim (auto-install if not present)

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- PLUGINS
-- ============================================================================
-- All plugins are defined here. lazy.nvim will auto-install them on first run.

require('lazy').setup({
  -- ----------------------------------------------------------------------------
  -- TELESCOPE - Fuzzy finder for files, text, buffers
  -- ----------------------------------------------------------------------------
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('telescope').setup({
        defaults = {
          -- Use terminal colors
          -- File ignore patterns
          file_ignore_patterns = { 'node_modules', '.git/', 'dist/', 'build/' },
          -- Layout
          layout_strategy = 'horizontal',
          layout_config = {
            horizontal = { preview_width = 0.6 },
          },
        },
      })
    end,
  },

  -- Telescope extension for better performance
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    config = function()
      require('telescope').load_extension('fzf')
    end,
  },

  -- ----------------------------------------------------------------------------
  -- LSP (Language Server Protocol) - Code intelligence
  -- ----------------------------------------------------------------------------
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Mason: manages LSP server installations
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      -- Mason: also manages the formatter binaries conform.nvim shells out to
      'WhoIsSethDaniel/mason-tool-installer.nvim',
    },
    config = function()
      -- Setup Mason (LSP installer)
      require('mason').setup()
      require('mason-lspconfig').setup({
        -- Auto-install these language servers
        ensure_installed = {
          'ts_ls',      -- TypeScript/JavaScript
          'pyright',       -- Python
        },
      })
      require('mason-tool-installer').setup({
        -- Formatter binaries used by conform.nvim (see FORMATTING section below)
        ensure_installed = { 'ruff', 'stylua', 'prettier' },
      })

      -- LSP keybindings (activated when LSP attaches to buffer)
      local on_attach = function(_, bufnr)
        local opts = { buffer = bufnr }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)           -- Go to definition
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)           -- Find references
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)                 -- Show documentation
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)       -- Rename symbol
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)  -- Code actions
      end

      -- Configure and enable LSP servers (nvim-lspconfig's require('lspconfig').X.setup()
      -- "framework" is deprecated in favor of vim.lsp.config/vim.lsp.enable on Nvim 0.11+)
      vim.lsp.config('ts_ls', { on_attach = on_attach })
      vim.lsp.config('pyright', { on_attach = on_attach })   -- Python
      vim.lsp.enable({ 'ts_ls', 'pyright' })
    end,
  },

  -- ----------------------------------------------------------------------------
  -- FORMATTING (conform.nvim) - Format on save
  -- ----------------------------------------------------------------------------
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    config = function()
      require('conform').setup({
        formatters_by_ft = {
          python = { 'ruff_format' },
          javascript = { 'prettier' },
          typescript = { 'prettier' },
          javascriptreact = { 'prettier' },
          typescriptreact = { 'prettier' },
          lua = { 'stylua' },
        },
        format_on_save = {
          timeout_ms = 2000,
          lsp_format = 'fallback',
        },
      })
    end,
  },

  -- ----------------------------------------------------------------------------
  -- COMPLETION (nvim-cmp) - Autocomplete popup
  -- ----------------------------------------------------------------------------
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',    -- LSP completion source
      'hrsh7th/cmp-buffer',      -- Buffer text completion source
      'hrsh7th/cmp-path',        -- File path completion source
      'L3MON4D3/LuaSnip',        -- Snippet engine
      'saadparwaiz1/cmp_luasnip', -- Snippet completion source
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),        -- Ctrl+Space: trigger completion
          ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Enter: confirm if selected
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.confirm({ select = true })             -- Tab: accept completion
            else
              fallback()                                 -- Otherwise, insert tab
            end
          end, { 'i', 's' }),
          ['<C-n>'] = cmp.mapping.select_next_item(),    -- Ctrl+n: next suggestion
          ['<C-p>'] = cmp.mapping.select_prev_item(),    -- Ctrl+p: previous suggestion
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },  -- LSP completions (primary)
          { name = 'luasnip' },   -- Snippets
          { name = 'buffer' },    -- Text from current buffer
          { name = 'path' },      -- File paths
        }),
      })
    end,
  },

  -- ----------------------------------------------------------------------------
  -- TREESITTER - Better syntax highlighting
  -- ----------------------------------------------------------------------------
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup()

      -- Parsers for these languages (main branch has no `ensure_installed`/`auto_install`)
      local parsers = { 'typescript', 'tsx', 'javascript', 'python', 'lua', 'vim', 'vimdoc' }
      require('nvim-treesitter').install(parsers):wait(300000)

      -- Highlighting/indent are opt-in per buffer on main; wire them up for the languages above
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
          if not lang or not vim.tbl_contains(parsers, lang) then
            return
          end
          vim.treesitter.start(args.buf, lang)
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

  -- ----------------------------------------------------------------------------
  -- FILE TREE - nvim-tree
  -- ----------------------------------------------------------------------------
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- File icons
    config = function()
      require('nvim-tree').setup({
        view = {
          width = 30,
          side = 'left',
        },
        renderer = {
          group_empty = true,  -- Group empty folders
        },
        filters = {
          dotfiles = false,    -- Show dotfiles
          custom = { '.git', 'node_modules', '.cache' },
        },
      })
    end,
  },

  -- ----------------------------------------------------------------------------
  -- GIT INTEGRATION
  -- ----------------------------------------------------------------------------
  -- Gitsigns: Shows git changes in sign column
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({
        signs = {
          add          = { text = '+' },
          change       = { text = '~' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
        },
        current_line_blame = false,  -- Don't show blame by default
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          -- Keybindings for git operations
          local opts = { buffer = bufnr }
          vim.keymap.set('n', '<leader>gb', gs.toggle_current_line_blame, opts)  -- Toggle git blame
          vim.keymap.set('n', '<leader>gp', gs.preview_hunk, opts)               -- Preview hunk
          vim.keymap.set('n', ']c', gs.next_hunk, opts)                          -- Next change
          vim.keymap.set('n', '[c', gs.prev_hunk, opts)                          -- Previous change
        end,
      })
    end,
  },

  -- Fugitive: Git commands in vim
  {
    'tpope/vim-fugitive',
  },

  -- ----------------------------------------------------------------------------
  -- TODO HIGHLIGHTING
  -- ----------------------------------------------------------------------------
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('todo-comments').setup({
        keywords = {
          TODO = { icon = '󰄱 ', color = 'info' },
          HACK = { icon = ' ', color = 'warning' },
          WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
          PERF = { icon = ' ', color = 'default', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
          NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
          FIX = { icon = ' ', color = 'error', alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' } },
        },
        highlight = {
          pattern = [[.*<(KEYWORDS)\s*]], -- Match TODOs with : or not
        },
        search = {
          pattern = [[\b(KEYWORDS)\b]], -- Search pattern
        },
      })
    end,
  },

  -- ----------------------------------------------------------------------------
  -- QUALITY OF LIFE PLUGINS
  -- ----------------------------------------------------------------------------
  -- Auto-pairs: Auto-close brackets, quotes, etc.
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
  },

  -- Comment: Easy commenting with gcc/gc
  {
    'numToStr/Comment.nvim',
    config = true,
  },

  -- Surround: Manipulate surrounding quotes/brackets with ys/cs/ds
  {
    'kylechui/nvim-surround',
    version = '*',
    event = 'VeryLazy',
    config = true,
  },

  -- Tmux navigator: Ctrl-h/j/k/l moves between vim splits AND tmux panes
  -- seamlessly (see the "PANE NAVIGATION" section of ~/.tmux.conf).
  {
    'christoomey/vim-tmux-navigator',
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
      'TmuxNavigatePrevious',
    },
    keys = {
      { '<C-h>', '<cmd>TmuxNavigateLeft<CR>' },
      { '<C-j>', '<cmd>TmuxNavigateDown<CR>' },
      { '<C-k>', '<cmd>TmuxNavigateUp<CR>' },
      { '<C-l>', '<cmd>TmuxNavigateRight<CR>' },
    },
  },

  -- Which-key: Shows available keybindings
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      require('which-key').setup()
      -- Document existing key chains
      require('which-key').add({
        { '<leader>f', group = '[F]ind' },
        { '<leader>g', group = '[G]it' },
        { '<leader>c', group = '[C]ode' },
      })
    end,
  },
})

-- ============================================================================
-- KEYBINDINGS
-- ============================================================================
-- Custom keybindings (beyond those defined in plugin configs above)

-- Clear search highlighting with Escape
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- File tree toggle
vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle file [E]xplorer' })

-- Telescope keybindings
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[F]ind by [G]rep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = '[F]ind [B]uffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = 'Find Files (VSCode-style)' })

-- Window navigation (Ctrl-h/j/k/l) is bound by vim-tmux-navigator above,
-- so it also crosses seamlessly into tmux panes at the edge of vim's splits.

-- Buffer navigation
vim.keymap.set('n', '<S-l>', '<cmd>bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<S-h>', '<cmd>bprevious<CR>', { desc = 'Previous buffer' })

-- Stay in visual mode when indenting
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- Move text up and down in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- ============================================================================
-- AUTO COMMANDS
-- ============================================================================

-- Highlight on yank (brief flash when you yank text)
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- ============================================================================
-- NOTES FOR CUSTOMIZATION
-- ============================================================================
-- To customize this config:
--
-- 1. Change color scheme:
--    - This config uses your terminal colors by default
--    - To add a theme plugin, add it to the plugins section above
--      Example: { 'folke/tokyonight.nvim', config = function() vim.cmd('colorscheme tokyonight') end }
--
-- 2. Add more language servers:
--    - Add to ensure_installed in mason-lspconfig setup (line ~120)
--    - Add setup call like ts_ls/pyright (around line ~130)
--
-- 3. Change keybindings:
--    - Leader key shortcuts are defined with <leader> (space)
--    - Find them throughout this file or add your own in the KEYBINDINGS section
--
-- 4. Add more plugins:
--    - Add a new table entry in the require('lazy').setup({ ... }) section
--    - Format: { 'author/plugin-name', config = function() ... end }
--
-- 5. Adjust completion behavior:
--    - See nvim-cmp config section (around line ~145)
--    - Modify the mapping table to change Tab/Enter/Ctrl+Space behavior
--
-- ============================================================================
