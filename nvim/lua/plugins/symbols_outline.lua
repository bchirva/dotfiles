local symbols_outline = require("symbols-outline")

symbols_outline.setup {
    highlight_hovered_item = true,
    show_guides = true,
    auto_preview = true,
    position = 'right',
    relative_width = true,
    width = 25,
    auto_close = false,
    show_numbers = false,
    show_relative_numbers = false,
    -- show_symbol_details = true,
    preview_bg_highlight = 'Pmenu',
    keymaps = { -- These keymaps can be a string or a table for multiple keys
        close = { "<Esc>", "q" },
        goto_location = "<Cr>",
        focus_location = "o",
        hover_symbol = "<C-space>",
        toggle_preview = "K",
        rename_symbol = "r",
        code_actions = "a",
    },
    lsp_blacklist = {},
    symbol_blacklist = {},
    symbols = {
        File = { icon = "", hl = "@text.uri" },
        Module = { icon = "", hl = "@namespace" },
        Namespace = { icon = "{}", hl = "@namespace" },
        Package = { icon = "", hl = "@namespace" },
        Class = { icon = "𝓒", hl = "@type" },
        Method = { icon = "ƒ", hl = "@method" },
        Property = { icon = "", hl = "@method" },
        Field = { icon = "", hl = "@field" },
        Constructor = { icon = "", hl = "@constructor" },
        Enum = { icon = "∑", hl = "@type" },
        Interface = { icon = "󰙎", hl = "@type" },
        Function = { icon = "ƒ", hl = "@function" },
        Variable = { icon = "", hl = "@constant" },
        Constant = { icon = "", hl = "@constant" },
        String = { icon = "𝓐", hl = "@string" },
        Number = { icon = "#", hl = "@number" },
        Boolean = { icon = "?", hl = "@boolean" },
        Array = { icon = "[]", hl = "@constant" },
        Object = { icon = "⦿", hl = "@type" },
        Key = { icon = "󰌋", hl = "@type" },
        Null = { icon = "NULL", hl = "@type" },
        EnumMember = { icon = "", hl = "@field" },
        Struct = { icon = "𝓢", hl = "@type" },
        Event = { icon = "🗲", hl = "@type" },
        Operator = { icon = "+", hl = "@operator" },
        TypeParameter = { icon = "𝙏", hl = "@parameter" },
        Component = { icon = "", hl = "@function" },
        Fragment = { icon = "", hl = "@constant" },
    }
}

function toggle_tagbar_keymap()
    if vim.bo.filetype ~= "NvimTree" then
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>ss', '<cmd>SymbolsOutline<CR>', { noremap = true, silent = false })
    end
end

-- autocmd BufNewFile,BufRead,Filetype * :lua toggle_tagbar_keymap()
vim.cmd([[
autocmd Filetype * :lua toggle_tagbar_keymap()
]])
