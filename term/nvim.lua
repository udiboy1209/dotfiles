vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- Python
vim.g.python3_host_prog = vim.fn.expand('~/venvs/neovim/bin/python3')
-- Styling
vim.g.have_nerd_font = true
vim.o.signcolumn = 'yes'

-- Good defaults
vim.opt.showmatch = true
vim.opt.number = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.termguicolors = true
vim.opt.guicursor = 'n-v-c-sm-r-cr-o:ver25,i-ci-ve:hor20'
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 5

-- Show space characters
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Tabs
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4

-- Leader shortcuts
vim.keymap.set('n', '<Leader><cr>', ':nohl<cr>')
vim.keymap.set('!', '<Leader><Leader>', '<Esc>')
vim.keymap.set('x', '<Leader>y', '"+y')
vim.keymap.set('x', '<Leader>p', '"+p')
vim.keymap.set('n', '<Leader>i', ':bprev<cr>')
vim.keymap.set('n', '<Leader>o', ':bnext<cr>')
vim.keymap.set('n', '<Leader>cn', ':cn<cr>')
vim.keymap.set('n', '<Leader>cp', ':cp<cr>')
vim.keymap.set('n', '<Leader>cl', ':ccl<cr>')
vim.keymap.set('n', '<Leader>cw', ':cw<cr>')

-- Transparent BG
vim.cmd [[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
  highlight clear EndOfBuffer
]]


-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- Plug('dcampos/nvim-snippy')

require('lazy').setup({
  'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth
  'lewis6991/gitsigns.nvim', -- Add git add/modify/delete to signcol
  'tpope/vim-fugitive', -- git commands within vim
  'tpope/vim-surround', -- you-surround commands
  'tpope/vim-commentary', -- add/remove comments
  {
    'feline-nvim/feline.nvim', -- feline statusbar
    opts = {}
  },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      -- load the colorscheme here
      vim.cmd.colorscheme('tokyonight')
    end,
  },
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        defaults = {
          mappings = {
            i = { ['<esc>'] = require('telescope.actions').close },
          },
        },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },
      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function()
      vim.print("Nvim-lspconfig")
      --  This function gets run when an LSP attaches to a particular buffer.
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Rename the variable under your cursor.
          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
          -- Execute a code action, usually your cursor needs to be on top of an error
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
          -- Find references for the word under your cursor.
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          -- Jump to the implementation of the word under your cursor.
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          -- Jump to the definition of the word under your cursor.
          map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          -- WARN: This is not Goto Definition, this is Goto Declaration.
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          -- Fuzzy find all the symbols in your current document.
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
          -- Fuzzy find all the symbols in your current workspace.
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
          -- Jump to the type of the word under your cursor.
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>ih', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, 'Toggle [I]nlay [H]ints')
          end
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      -- create new capabilities with blink.cmp, and then broadcast that to the servers.
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Enable the following language servers
      local servers = {
        pyright = {
          root_markers = { ".venv", "pyproject.toml", "setup.py", ".git", "pyrightconfig.json" },
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "off",
              },
            },
          },
        },
        ruff = {
          root_markers = { ".venv", ".git", "pyproject.toml", "ruff.toml" },
        },
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, { 'stylua', 'pyright', 'ruff' })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      for server_name, server in pairs(servers) do
        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        vim.lsp.config(server_name, server)
      end

      require('mason-lspconfig').setup {}
    end,
  },
  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    debug = true,
    opts = {
      keymap = {
        -- See :h blink-cmp-config-keymap for defining your own keymap
        preset = 'default',
        ['<c-;>'] = { 'select_and_accept', 'fallback' }
      },
      appearance = { nerd_font_variant = 'mono', },
      completion = {
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
      },
      sources = {
        default = { 'lsp', 'buffer', 'path', 'snippets' },
      },
      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'prefer_rust_with_warning' },
      signature = { enabled = true },
    },
    dependencies = { 'L3MON4D3/LuaSnip' }
  },
  {
    'nvim-tree/nvim-tree.lua',
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {}
      vim.keymap.set('n', '<leader>t', ':NvimTreeFocus<CR>', { desc = '[T]ree Toggle and Focus' })
    end,
  },
  {
    'L3MON4D3/LuaSnip',
    version = "v2.*",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      -- Can load custom snippets using additional loads
      -- require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/lua/snippets/" })
    end,
    dependencies = { 'rafamadriz/friendly-snippets' }
  }
})

-- vim: ts=2 sts=2 sw=2 et
