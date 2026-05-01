vim.pack.add({"https://github.com/nvim-lualine/lualine.nvim"})

require("lualine").setup({
    options = {
        component_separators = {
            left = "",
            right = "",
        },
        section_separators = {
            left = "",
            right = "",
        },
    },
    sections = {
        lualine_x = { "encoding", "filetype", "lsp_status" },
    },
    extensions = { "nvim-tree" },
})

