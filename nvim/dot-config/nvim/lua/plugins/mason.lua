CPP = { "clangd", "codelldb", "clang-format" }
PYTHON = { "pyright", "debugpy", "flake8", "isort", "black" }
JS = { "eslint_d", "prettier" }
LUA = { "lua-language-server", "stylua" }
WEB = { "css-lsp" }

return {
	{
		"williamboman/mason.nvim",
		opts = {},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = {
			ensure_installed = {
				unpack(CPP),
				unpack(PYTHON),
				unpack(JS),
				unpack(LUA),
				unpack(WEB),
			},
		},
	},
}
