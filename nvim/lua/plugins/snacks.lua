local snacks = require("snacks")

snacks.setup({
    indent = { enabled = true },
    input = { enabled = true },
    scroll = { enabled = true },
    image = { enabled = true },
    lazygit = { enabled = true },
    notifier = { enabled = true }
})

vim.keymap.set('n', '<leader>gl', "<cmd>lua Snacks.lazygit.open()<CR>", { noremap = true, silent = true })
