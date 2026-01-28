vim.opt.encoding = "utf-8"
vim.opt.compatible = false
vim.opt.autochdir = false
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
vim.opt.mouse = "a"
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.winborder = "rounded"
vim.opt.belloff = "all"
vim.g.mapleader = " "
vim.opt.clipboard:append("unnamedplus")

require("theme/highlights").setup()

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins")
