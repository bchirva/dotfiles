local comment = require("todo-comments")

comment.setup {}

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<leader>fc', '<cmd>TodoTelescope<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>sc', '<cmd>Trouble todo toggle<CR>', opts)
