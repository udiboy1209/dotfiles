-- Plugins
local Plug = vim.fn['plug#']
vim.call('plug#begin')

Plug('tpope/vim-fugitive')
Plug('tpope/vim-surround')
Plug('tpope/vim-commentary')
Plug('navarasu/onedark.nvim')
Plug('feline-nvim/feline.nvim')
Plug('rightson/vim-p4-syntax')
Plug('dcampos/nvim-snippy')
Plug('duane9/nvim-rg')
Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim')
Plug('neovim/nvim-lspconfig')

vim.call('plug#end')

-- Good defaults
vim.opt.showmatch = true
vim.opt.number = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.termguicolors = true
vim.opt.guicursor = "n-v-c-sm-r-cr-o:ver25,i-ci-ve:hor20"
vim.g.mapleader = ","

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

-- OneDark colorscheme
require('onedark').setup {
    style = 'darker',
    transparent = true
}
require('onedark').load()

-- Feline statusbar
require('feline').setup()

local c = require('onedark.colors')
local feline_onedark = {
    fg = c.fg,
    bg = c.bg0,
    black = c.black,
    skyblue = c.blue,
    cyan = c.cyan,
    green = c.green,
    oceanblue = c.bg_blue,
    magenta = c.dark_red,
    orange = c.orange,
    red = c.red,
    violet = c.purple,
    white = '#FFFFFF',
    yellow = c.yellow
}

require('feline').use_theme(feline_onedark)

require('snippy').setup({
    mappings = {
        is = {
            ['<Tab>'] = 'expand_or_advance',
            ['<S-Tab>'] = 'previous',
        },
        nx = {
            ['<leader>x'] = 'cut_text',
        },
    },
})

-- Setup language server
require('lspconfig').jedi_language_server.setup({})

vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<Leader>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gk', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gK', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<Leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<Leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<Leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<Leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<Leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<Leader>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

vim.opt.completeopt = 'menu'
vim.keymap.set('i', '<C-O>', '<C-X><C-O>')
