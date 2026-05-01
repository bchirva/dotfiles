vim.pack.add({ "https://github.com/kyazdani42/nvim-tree.lua" })

require("nvim-tree").setup({
    hijack_cursor = true,
    git = { enable = false },
})

vim.keymap.set("n", "<leader>sf", "<cmd>NvimTreeToggle<CR>", { desc = "NvimTree" })

local colors = require("theme/colors")
require("theme/highlight").set(
    {
        NvimTreeSymlink    = { italic = true },
        NvimTreeExecFile   = { fg = colors.warning },
        NvimTreeFolderIcon = { fg = colors.primary },
    }
)
