local gitsigns = require('gitsigns')

gitsigns.setup {
    signs = {
        add          = { text = '+' },
        change       = { text = '~' },
        delete       = { text = '-' },
        topdelete    = { text = '-' },
        changedelete = { text = '~' },
        untracked    = { text = '?' }
    },
    signs_staged = {
        add          = { text = '+' },
        change       = { text = '~' },
        delete       = { text = '-' },
        topdelete    = { text = '-' },
        changedelete = { text = '~' },
        untracked    = { text = '?' }
    }
}

-- vim.keymap.set('n', 'gnh', '<cmd>Gitsigns next_hunk<CR>')
-- vim.keymap.set('n', 'gph', '<cmd>Gitsigns prev_hunk<CR>')
vim.keymap.set('n', '<leader>gn', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr = true})
vim.keymap.set('n', '<leader>gp', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr = true})

vim.keymap.set('n', '<leader>gv', '<cmd>Gitsigns preview_hunk<CR>')
-- vim.keymap.set({'n', 'v'}, '<leader>sh', '<cmd>Gitsigns stage_hunk<CR>')
vim.keymap.set({'n', 'v'}, '<leader>gr', '<cmd>Gitsigns reset_hunk<CR>')
vim.keymap.set('n', '<leader>gs', '<cmd>Gitsigns stage_buffer<CR>')
vim.keymap.set('n', '<leader>gc', '<cmd>Gitsigns reset_buffer<CR>')

vim.keymap.set('n', '<leader>gw', '<cmd>Gitsigns toggle_current_line_blame<CR>')
vim.keymap.set('n', '<leader>gf', '<cmd>Gitsigns diffthis<CR>')

