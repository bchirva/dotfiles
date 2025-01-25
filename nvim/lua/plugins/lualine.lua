local lualine = require("lualine")

lualine.setup {
    options = {
        component_separators = {
            left = '',
            right = ''
        },
        section_separators = {
            left = '',
            right = ''
        }
    },
    sections = {
        lualine_x = { 'encoding', 'filetype' }
    },
    extensions = { 'nvim-tree' }
}
