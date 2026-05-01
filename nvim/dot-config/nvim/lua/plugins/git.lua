vim.pack.add({"https://github.com/lewis6991/gitsigns.nvim"})

require("gitsigns").setup({
    signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "-" },
        topdelete = { text = "-" },
        changedelete = { text = "~" },
        untracked = { text = "?" },
    },
    signs_staged = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "-" },
        topdelete = { text = "-" },
        changedelete = { text = "~" },
        untracked = { text = "?" },
    },
})

vim.keymap.set("n", "<leader>gn", "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { desc = "Next hunk",  expr = true })
vim.keymap.set("n", "<leader>gp", "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { desc = "Prev hunk", expr = true })
vim.keymap.set("n", "<leader>gv", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Preview hunk" })
vim.keymap.set({"n", "v"}, "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", { desc = "Reset hunk" })
vim.keymap.set({"n", "v"}, "<leader>gs", "<cmd>Gitsigns stage_buffer<CR>", { desc = "Stage buffer" })
vim.keymap.set("n", "<leader>gc", "<cmd>Gitsigns reset_buffer<CR>", { desc = "Reset buffer" })
vim.keymap.set("n", "<leader>gw", "<cmd>Gitsigns toggle_current_line_blame<CR>", { desc = "Blame line" })
vim.keymap.set("n", "<leader>gf", "<cmd>Gitsigns diffthis<CR>", { desc = "Diff this" })
