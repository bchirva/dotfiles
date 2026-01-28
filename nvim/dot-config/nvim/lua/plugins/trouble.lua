return {
	"folke/trouble.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	cmd = "Trouble",
	opts = {},
	keys = {
		{ "<leader>sd", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics" },
		{ "<leader>ss", "<cmd>Trouble symbols toggle focus=true<CR>", desc = "Symbols" },
		{ "<leader>sl", "<cmd>Trouble lsp toggle<CR>", desc = "LSP" },
	},
}
