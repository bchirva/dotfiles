-- General options --

vim.opt.mouse = "a"
vim.opt.clipboard:append("unnamedplus")
vim.g.mapleader = " "
vim.opt.swapfile = false

vim.opt.showcmd = true
vim.opt.showmode = false
vim.opt.showbreak = "󰘍"
vim.opt.showmatch = true
vim.opt.matchpairs:append("<:>")

vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.wrap = false
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 10

vim.opt.termguicolors = true
vim.opt.winborder = "rounded"
vim.opt.pumborder = "rounded"

vim.opt.completeopt = { "menu", "menuone", "noselect", "preview" }

-- Theme --

-- require("highlights")
-- require("theme")
require("theme/builtin").setup()

-- Plugins --

for name, type in vim.fs.dir(vim.fn.stdpath("config") .. "/lua/plugins") do
    if type == "file" and name:match("%.lua$") then
        require("plugins." .. name:gsub("%.lua$", ""))
    end
end

-- Key bindings --

vim.keymap.set("n", "<C-l>", "<cmd>wincmd l<CR>")
vim.keymap.set("n", "<C-j>", "<cmd>wincmd j<CR>")
vim.keymap.set("n", "<C-h>", "<cmd>wincmd h<CR>")
vim.keymap.set("n", "<C-k>", "<cmd>wincmd k<CR>")
vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "New tab" })
vim.keymap.set("n", "<leader>tn", "<cmd>tabnext<CR>", { desc = "Next tab" })
vim.keymap.set("n", "<leader>tp", "<cmd>tabprevious<CR>", { desc = "Prev tab" })
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "Close tab" })
vim.keymap.set("n", "<leader>\\", "<cmd>vsplit<CR>", { desc = "Vertical split" })
vim.keymap.set("n", "<leader>-", "<cmd>split<CR>", { desc = "Horizontal split" })
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", "<cmd>bprev<CR>", { desc = "Prev buffer" })
vim.keymap.set("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", "<cmd>bprev<CR>", { desc = "Prev buffer" })
vim.keymap.set("n", "<leader>nh", ":nohlsearch<CR>", { desc = "Reset highlight" })
vim.keymap.set("i", "<C-a>", "<C-o>^", { silent = true })
vim.keymap.set("i", "<C-e>", "<C-o>$", { silent = true })
