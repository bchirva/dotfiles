return {
	"neovim/nvim-lspconfig",
	keys = {
		{ "<leader>lD", vim.lsp.buf.declaration, desc = "LSP go to declaration" },
		{ "<leader>ld", vim.lsp.buf.definition, desc = "LSP go to definition" },
		{ "<leader>lh", vim.lsp.buf.hover, desc = "LSP hover" },
		{ "<leader>li", vim.lsp.buf.implementation, desc = "LSP implementation" },
		{ "<leader>lt", vim.lsp.buf.type_definition, desc = "LSP type definition" },
		{ "<leader>lr", vim.lsp.buf.rename, desc = "LSP rename" },
		{ "<leader>la", vim.lsp.buf.code_action, desc = "LSP code action" },
		-- {'<leader>lu', vim.lsp.buf.references},
		-- {'<leader>lf', vim.lsp.buf.format},
	},
	lazy = false,
	config = function()
		local lspconfig = require("lspconfig")
		local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

		local servers = { "pyright", "ts_ls", "cssls" }
		for _, lsp in pairs(servers) do
			lspconfig[lsp].setup({
				capabilities = capabilities,
			})
		end

		lspconfig["clangd"].setup({
			capabilities = capabilities,
			cmd = { "clangd", "--completion-style=detailed" },
		})

		lspconfig["bashls"].setup({
			capabilities = capabilities,
			cmd = { "bash-language-server", "start" },
		})

		-- LSP for Lua
		lspconfig["lua_ls"].setup({
			settings = {
				Lua = {
					runtime = {
						-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
						version = "LuaJIT",
					},
					diagnostics = {
						-- Get the language server to recognize the `vim` global
						globals = { "vim" },
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
		})
	end,
}

-- local lsp_keybindings = function(client, bufnr)
--     local bufopts = { noremap = true, silent = true, buffer = bufnr }
-- end
