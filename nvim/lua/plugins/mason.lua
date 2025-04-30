return {
	{
		"williamboman/mason.nvim",
		opts = {},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			auto_install = true,
			ensure_installed = { "lua_ls", "clangd", "pyright" },
		},
	},
}
