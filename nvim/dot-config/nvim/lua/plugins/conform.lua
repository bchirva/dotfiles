vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        python = { "black", "isort" },
    },
    default_format_opts = {
        lsp_format = "fallback",
    },
    format_on_save = {
        lsp_fallback = false,
        async = false,
        timeout_ms = 500,
    }
})

vim.keymap.set("n", "<leader>lf", function()
    require("conform").format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 500,
    })
end, { desc = "LSP format" })
