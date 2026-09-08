vim.pack.add({"https://github.com/akinsho/bufferline.nvim"})

local colors = require("theme/colors")

require("bufferline").setup({
    options = {
        mode = "buffers",
        offsets = { { filetype = "NvimTree", text = "File Explorer" } },
    },
    highlights = {
        background = { fg = colors.foreground_dim, bg = colors.background },
        fill = { fg = colors.foreground_dim, bg = colors.background },
        tab = { fg = colors.foreground_dim, bg = colors.background },
        tab_selected = { fg = colors.accent, bg = colors.accent_contrast },
        buffer_visible = { fg = colors.foreground_dim, bg = colors.background },
        buffer_selected = {
            fg = colors.accent, bg = colors.accent_contrast,
            bold = true, italic = true },

        duplicate = { fg = colors.foreground_dim, bg = colors.background, italic = true },
        duplicate_selected = { fg = colors.accent, bg = colors.accent_contrast, italic = true },
        duplicate_visible = { fg = colors.foreground_dim, bg = colors.background, italic = true },

        close_button = { fg = colors.foreground_dim, bg = colors.background },
        close_button_visible = { fg = colors.foreground_dim, bg = colors.background },
        close_button_selected = { fg = colors.foreground, bg = colors.accent_contrast },

        modified = { fg = colors.error, bg = colors.background },
        modified_visible = { fg = colors.error, bg = colors.background },
        modified_selected = { fg = colors.error, bg = colors.accent_contrast },

        indicator_visible = { fg = colors.foreground, bg = colors.background },
        indicator_selected = { fg = colors.accent, bg = colors.accent_contrast },

        separator = { fg = colors.foreground_dim, bg = colors.background },
        separator_selected = { fg = colors.foreground, bg = colors.background },
        separator_visible = { fg = colors.foreground_dim, bg = colors.background },
        tab_separator = { fg = colors.foreground_dim, bg = colors.background},
        tab_separator_selected = {
            fg = colors.accent, bg = colors.accent_contrast,
            sp = colors.error, underline = false,
        },
    }
})
