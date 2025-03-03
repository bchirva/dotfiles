local trouble = require("trouble")

trouble.setup {}

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>sd', '<cmd>Trouble diagnostics toggle<CR>', opts)
vim.keymap.set('n', '<leader>ss', '<cmd>Trouble symbols toggle focus=true<CR>', opts)
vim.keymap.set('n', '<leader>sl', '<cmd>Trouble lsp toggle<CR>', opts)


local signs = { Error = " ", Warn = " ", Info = " ", Hint = "󰅺" }
-- local signs = { Error = " ", Warn = " ", Info = " ", Hint = "" }

for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
