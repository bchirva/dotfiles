vim.opt.encoding = "utf-8"
vim.opt.compatible = false

vim.cmd([[
filetype indent plugin on
syntax enable
]])

vim.opt.autochdir = true

vim.opt.showcmd = true
vim.opt.showmode = true
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.hlsearch = true
vim.opt.showmatch = true
vim.opt.matchpairs:append("<:>")
vim.opt.showbreak = "󰘍"
vim.opt.wrap = false 

vim.opt.mouse = 'a'

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.swapfile = false

vim.opt.termguicolors = true
vim.opt.belloff = "all"

vim.g.mapleader = ' '

vim.opt.clipboard:append("unnamedplus")

require("theme/highlights").setup()
