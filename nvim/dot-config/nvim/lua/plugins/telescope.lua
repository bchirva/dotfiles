vim.pack.add({ "https://github.com/nvim-telescope/telescope.nvim" })

require("telescope").setup()

vim.keymap.set("n", "<leader>ff", function()
    require("telescope.builtin").find_files({ hidden = true })
end, { desc = "Find files" })
vim.keymap.set("n", "<leader>bf", require("telescope.builtin").buffers, { desc = "Find buffer" })
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep, { desc = "Find text via grep" })
vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags, { desc = "Help tags" })
vim.keymap.set("n", "<leader>l/", "<cmd>Telescope lsp_references<CR>", { desc = "LSP references" })


require("theme/highlight").set(
    {
        TelescopeTitle = { link = "Title" }
    }
)
