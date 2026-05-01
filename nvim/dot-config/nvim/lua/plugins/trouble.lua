vim.pack.add({ "https://github.com/folke/trouble.nvim" })

require("trouble").setup()

vim.keymap.set("n", "<leader>sd", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>ss", "<cmd>Trouble symbols toggle focus=true<CR>", { desc = "Symbols" })
vim.keymap.set("n", "<leader>sl", "<cmd>Trouble lsp toggle<CR>", { desc = "LSP" })

require("theme/highlight").set(
    {
        TroubleNormal   = { link = "Normal" },
        TroubleNormalNC = { link = "Normal" },
        TroubleIndent   = { link = "Normal" },
    }
)
