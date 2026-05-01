vim.pack.add({ "https://github.com/folke/which-key.nvim" })

local which_key = require("which-key")

which_key.setup({
    win = {
        border = "rounded",
    },
})

vim.keymap.set("n", "<leader>?", "<cmd>WhichKey<CR>", { desc = "WhichKey" })

which_key.add({
    { "<leader>c", group = "Comment..." },
    { "<leader>b", group = "Buffers..." },
    { "<leader>d", group = "DAP..." },
    { "<leader>l", group = "LSP..." },
    { "<leader>f", group = "Telescope..." },
    { "<leader>g", group = "Git..." },
    { "<leader>s", group = "Splits..." },
    { "<leader>t", group = "Tabs..." },
    { "<leader>q", group = "Tests..." },
    { "<leader>u", group = "Utilities..." },
})
