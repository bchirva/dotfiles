local trouble = require("trouble")

trouble.setup {}


local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>sd', '<cmd>Trouble diagnostics toggle<CR>', opts)
vim.keymap.set('n', '<leader>ss', '<cmd>Trouble symbols toggle focus=true<CR>', opts)
vim.keymap.set('n', '<leader>sl', '<cmd>Trouble lsp toggle<CR>', opts)
