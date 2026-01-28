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
		{ "<leader>ls", vim.lsp.buf.signature_help, desc = "LSP signature help" },
		-- {'<leader>lu', vim.lsp.buf.references},
		-- {'<leader>lf', vim.lsp.buf.format},
	},
	lazy = false,
	config = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

		vim.lsp.config("*", {
			capabilities = capabilities,
		})

		vim.lsp.enable({ "clangd", "pyright", "lua_ls", "bashls", "ts_ls", "cssls" })
	end,
}
