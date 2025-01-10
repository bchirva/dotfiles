local lsp_keybindings = function(client, bufnr)
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', '<leader>lD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', '<leader>ld', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', '<leader>lh', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<leader>lu', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<leader>li', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<leader>lt', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, bufopts)
  -- vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, bufopts)
end

local lspconfig = require("lspconfig")

local client_capabilities = vim.lsp.protocol.make_client_capabilities()
local capabilities = require("cmp_nvim_lsp").default_capabilities(client_capabilities)

--[[ local setupLspServer = function(server, opts)
    local serverConfig = {
        on_attach = lsp_keybindings,
        capabilities = capabilities
    } 

    lspconfig[server].setup(serverConfig)
end
 ]]

 -- Default LSP
local servers = { 'rust_analyzer', 'pyright', 'ts_ls', 'cssls' }
for _, lsp in pairs(servers) do
  lspconfig[lsp].setup {
    on_attach = lsp_keybindings,
    capabilities = capabilities
  }
end

lspconfig['clangd'].setup {
    on_attach = lsp_keybindings,
    capabilities = capabilities,
    cmd = {"clangd", "--completion-style=detailed"}
}

-- LSP for Lua
lspconfig['lua_ls'].setup {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}
