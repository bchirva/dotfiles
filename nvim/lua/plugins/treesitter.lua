local treesitter = require("nvim-treesitter.configs")

treesitter.setup {
    ensure_installed = { "c", "cpp", "cmake", "glsl", "html", "css", "scss", "javascript", "vue", "json", "lua", "python", "rust" },
    sync_install = false,
    auto_install = true,
    ignore_install = {},

    highlight = {
        enable = true,
        disable = {},
        additional_vim_regex_highlighting = true,
    }
}
