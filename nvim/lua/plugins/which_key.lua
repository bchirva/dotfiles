local opts = { noremap = true, silent = true }

-- vim.api.nvim_set_keymap('n', '<leader>l', '<C-w><C-l>', opts)
-- vim.api.nvim_set_keymap('n', '<leader>j', '<C-w><C-j>', opts)
-- vim.api.nvim_set_keymap('n', '<leader>h', '<C-w><C-h>', opts)
-- vim.api.nvim_set_keymap('n', '<leader>k', '<C-w><C-k>', opts)

vim.api.nvim_set_keymap('n', '<C-l>', '<C-w><C-l>', opts)
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w><C-j>', opts)
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w><C-h>', opts)
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w><C-k>', opts)

vim.api.nvim_set_keymap('n', '<leader>s.', '<cmd>vertical resize +10<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>s,', '<cmd>vertical resize -10<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>s=', '<cmd>resize +10<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>s-', '<cmd>resize -10<CR>', opts)

vim.api.nvim_set_keymap('n', '<leader>to', '<cmd>tabnew<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>tn', '<cmd>tabnext<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>tp', '<cmd>tabprevious<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>tc', '<cmd>tabclose<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>sv', '<cmd>vsplit<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>sh', '<cmd>split<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>bn', '<cmd>bnext<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>bp', '<cmd>bprev<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>bc', '<cmd>BufferLinePick<CR>', opts)
vim.api.nvim_set_keymap('n', '<Tab>', '<cmd>bnext<CR>', opts)
vim.api.nvim_set_keymap('n', '<S-Tab>', '<cmd>bprev<CR>', opts)


vim.api.nvim_set_keymap('n', '<leader>nh', ':nohlsearch<CR>', opts)

local which_ley = require("which-key")
which_ley.setup {}

which_ley.add({
    { "<leader>nh", desc = "No highlight" },
    { "<leader>c",  group = "Comment..." },

    { "<leader>b",  group = "Buffers..." },
    { "<leader>bn", desc = "Next buffer" },
    { "<leader>bp", desc = "Prev buffer" },
    { "<leader>bc", desc = "Pick buffer" },

    { "<leader>d",  group = "DAP..." },
    { "<leader>dc", desc = "DAP continue" },
    { "<leader>di", desc = "DAP step into" },
    { "<leader>dn", desc = "DAP step over" },
    { "<leader>do", desc = "DAP step out" },
    { "<leader>dp", desc = "DAP step back" },
    { "<leader>dt", desc = "DAP toggle breakpoint" },
    { "<leader>du", desc = "DAP toggle UI" },

    { "<leader>f",  group = "Telescope..." },
    { "<leader>fc", desc = "Find comments" },
    { "<leader>ff", desc = "Find files" },
    { "<leader>fg", desc = "Find text via grep" },
    { "<leader>fb", desc = "Find buffer" },
    { "<leader>fh", desc = "Help tags" },

    { "<leader>g",  group = "Gitsigns..." },
    { "<leader>gc", desc = "Reset buffer" },
    { "<leader>gf", desc = "Diff" },
    { "<leader>gn", desc = "Next hunk" },
    { "<leader>gp", desc = "Prev hunk" },
    { "<leader>gr", desc = "Reset hunk" },
    { "<leader>gs", desc = "Stage buffer" },
    { "<leader>gv", desc = "Preview hunk" },
    { "<leader>gw", desc = "Blame" },
    { "<leader>gl", desc = "LazyGit" },

    { "<leader>l",  group = "LSP..." },
    { "<leader>la", desc = "LSP code action" },
    { "<leader>ld", desc = "LSP go to definition" },
    { "<leader>lD", desc = "LSP go to declaration" },
    { "<leader>lf", desc = "LSP format" },
    { "<leader>lh", desc = "LSP hover" },
    { "<leader>li", desc = "LSP implementation" },
    { "<leader>lr", desc = "LSP rename" },
    { "<leader>lt", desc = "LSP type definition" },
    { "<leader>lu", desc = "LSP references" },

    { "<leader>s",  group = "Splits..." },
    { "<leader>sf", desc = "NvimTree" },
    { "<leader>sd", desc = "Trouble (diagnostics)" },
    -- {"<leader>ss", desc = "SymbolsOutline"},
    { "<leader>ss", desc = "Trouble (symbols)" },
    { "<leader>sl", desc = "Trouble (LSP)" },
    { "<leader>sc", desc = "Show comments" },
    { "<leader>sr", desc = "NvimTree refresh" },
    { "<leader>sh", desc = "Split horizontal" },
    { "<leader>sv", desc = "Split vertical" },

    { "<leader>t",  group = "Tabs..." },
    { "<leader>tc", desc = "Close tab" },
    { "<leader>tn", desc = "Next tab" },
    { "<leader>to", desc = "New tab" },
    { "<leader>tp", desc = "Prev tab" }

})

-- which_ley.register({
--     ["<leader>"] = {
--         ["nh"] = "No highlight",
--         b = {
--             name = "Buffers...",
--             n = "Next buffer",
--             p = "Prev buffer",
--         },
--         c = {
--             name = "Comment..."
--         },
--         d = {
--             name = "DAP...",
--             c = "DAP continue",
--             i = "DAP step into",
--             n = "DAP step over",
--             o = "DAP step out",
--             p = "DAP step back",
--             t = "DAP toggle breakpoint",
--             u = "DAP toggle UI"
--         },
--         f = {
--             name = "Telescope",
--             f = "Find files",
--             g = "Find text via grep",
--             b = "Find buffer",
--             h = "Help tags"
--         },
--         g = {
--             name = "Gitsigns...",
--             c = "Reset buffer",
--             f = "Diff",
--             n = "Next hunk",
--             p = "Prev hunk",
--             r = "Reset hunk",
--             s = "Stage buffer",
--             v = "Preview hunk",
--             w = "Blame"
--         },
--         l = {
--             name = "LSP...",
--             a = "LSP code action",
--             d = "LSP go to definition",
--             D = "LSP go to declaration",
--             f = "LSP format",
--             h = "LSP hover",
--             i = "LSP implementation",
--             r = "LSP rename",
--             t = "LSP type definition",
--             u = "LSP references"
--         },
--         s = {
--             name = "Splits...",
--             d = "Trouble diagnostics",
--             f = "NvimTree",
--             h = "Split horizontal",
--             r = "NvimTree refresh",
--             s = "SymbolsOutline",
--             v = "Split vertical"
--         },
--         t = {
--             name = "Tabs...",
--             c = "Close tab",
--             n = "Next tab",
--             o = "New tab",
--             p = "Prev tab"
--         }
--     }
-- })
