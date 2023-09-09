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
vim.keymap.set('', '<Leader><Leader>', '<Esc>')
vim.keymap.set('x', '<Leader>y', '"+y')
vim.keymap.set('x', '<Leader>p', '"+p')
vim.keymap.set('n', '<Leader>i', ':bprev<cr>')
vim.keymap.set('n', '<Leader>o', ':bnext<cr>')

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
