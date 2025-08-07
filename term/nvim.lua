-- Plugins
local Plug = vim.fn['plug#']
vim.call('plug#begin')

Plug('tpope/vim-fugitive')
Plug('tpope/vim-surround')
Plug('tpope/vim-commentary')
Plug('dcampos/nvim-snippy')
Plug('feline-nvim/feline.nvim')

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

vim.opt.completeopt = 'menu'
