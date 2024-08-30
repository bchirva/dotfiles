local mason = require("mason")
local mason_lsp = require("mason-lspconfig")

mason.setup()
mason_lsp.setup{
    ensure_installed = {"clangd", "rust_analyzer", "lua_ls", "pyright"}
}
