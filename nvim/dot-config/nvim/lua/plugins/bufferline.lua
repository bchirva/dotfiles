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

        close_button = { fg = colors.foreground_dim, bg = colors.background },
        close_button_visible = { fg = colors.foreground_dim, bg = colors.background },
        close_button_selected = { fg = colors.foreground, bg = colors.accent_contrast },

        modified = { fg = colors.warning, bg = colors.background },
        modified_visible = { fg = colors.warning, bg = colors.background },
        modified_selected = { fg = colors.warning, bg = colors.accent_contrast },

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

        --     tab_separator = {
        --       fg = '<colour-value-here>',
        --       bg = '<colour-value-here>',
        --     },
        --     tab_separator_selected = {
        --       fg = '<colour-value-here>',
        --       bg = '<colour-value-here>',
        --       sp = '<colour-value-here>',
        --       underline = '<colour-value-here>',
        --     },
        --     tab_close = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --     },
        --     numbers = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --     },
        --     numbers_visible = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --     },
        --     numbers_selected = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --         bold = true,
        --         italic = true,
        --     },
        --     diagnostic = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --     },
        --     diagnostic_visible = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --     },
        --     diagnostic_selected = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --         bold = true,
        --         italic = true,
        --     },
        --     hint = {
        --         fg = '<colour-value-here>',
        --         sp = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --     },
        --     hint_visible = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --     },
        --     hint_selected = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --         sp = '<colour-value-here>',
        --         bold = true,
        --         italic = true,
        --     },
        --     hint_diagnostic = {
        --         fg = '<colour-value-here>',
        --         sp = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --     },
        --     hint_diagnostic_visible = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --     },
        --     hint_diagnostic_selected = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --         sp = '<colour-value-here>',
        --         bold = true,
        --         italic = true,
        --     },
        --     info = {
        --         fg = '<colour-value-here>',
        --         sp = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --     },
        --     info_visible = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --     },
        --     info_selected = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --         sp = '<colour-value-here>',
        --         bold = true,
        --         italic = true,
        --     },
        --     info_diagnostic = {
        --         fg = '<colour-value-here>',
        --         sp = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --     },
        --     info_diagnostic_visible = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --     },
        --     info_diagnostic_selected = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --         sp = '<colour-value-here>',
        --         bold = true,
        --         italic = true,
        --     },
        --     warning = {
        --         fg = '<colour-value-here>',
        --         sp = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --     },
        --     warning_visible = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --     },
        --     warning_selected = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --         sp = '<colour-value-here>',
        --         bold = true,
        --         italic = true,
        --     },
        --     warning_diagnostic = {
        --         fg = '<colour-value-here>',
        --         sp = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --     },
        --     warning_diagnostic_visible = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --     },
        --     warning_diagnostic_selected = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --         sp = '<colour-value-here>',
        --         bold = true,
        --         italic = true,
        --     },
        --     error = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --         sp = '<colour-value-here>',
        --     },
        --     error_visible = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --     },
        --     error_selected = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --         sp = '<colour-value-here>',
        --         bold = true,
        --         italic = true,
        --     },
        --     error_diagnostic = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --         sp = '<colour-value-here>',
        --     },
        --     error_diagnostic_visible = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --     },
        --     error_diagnostic_selected = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --         sp = '<colour-value-here>',
        --         bold = true,
        --         italic = true,
        --     },
        --     modified = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --     },
        --     modified_visible = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --     },
        --     modified_selected = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --     },
        --     duplicate_selected = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --         italic = true,
        --     },
        --     duplicate_visible = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --         italic = true,
        --     },
        --     duplicate = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --         italic = true,
        --     },
        --     separator_selected = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --     },
        --     separator_visible = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --     },
        --     separator = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --     },
        --     indicator_visible = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --     },
        --     indicator_selected = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --     },
        --     pick_selected = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --         bold = true,
        --         italic = true,
        --     },
        --     pick_visible = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --         bold = true,
        --         italic = true,
        --     },
        --     pick = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --         bold = true,
        --         italic = true,
        --     },
        --     offset_separator = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --     },
        --     trunc_marker = {
        --         fg = '<colour-value-here>',
        --         bg = '<colour-value-here>',
        --     }
