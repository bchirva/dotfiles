local nvim_tree = require("nvim-tree")

nvim_tree.setup {
    hijack_cursor = true,
    git = {
        enable = false
    }
}

vim.keymap.set('n', '<leader>sf', '<cmd>NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>sr', '<cmd>NvimTreeRefresh<CR>', { noremap = true, silent = true })

--vim.keymap.set('n', '<C-n>', '<cmd>NvimTreeToggle<CR>', {noremap = true, silent = true})
--vim.keymap.set('n', '<C-r>', '<cmd>NvimTreeRefresh<CR>', {noremap = true, silent = true})
