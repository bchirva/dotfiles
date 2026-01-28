return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local config = require("nvim-treesitter.configs")

        config.setup({
            ensure_installed = { "c", "cpp", "cmake", "glsl", "html", "css", "javascript", "json", "lua", "python", "rust" },
            sync_install = false,
            auto_install = true,
            ignore_install = {},
            indent = { enable = true },

            highlight = {
                enable = true,
                disable = {},
                additional_vim_regex_highlighting = true,
            }
        })
    end
}
