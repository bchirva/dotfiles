return {
	"folke/trouble.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	cmd = "Trouble",
	opts = {},
	keys = {
		{ "<leader>sd", "<cmd>Trouble diagnostics toggle<CR>", desc = "Trouble diagnostics" },
		{ "<leader>ss", "<cmd>Trouble symbols toggle focus=true<CR>", desc = "Trouble symbols" },
		{ "<leader>sl", "<cmd>Trouble lsp toggle<CR>", desc = "Trouble LSP" },
	},
}
