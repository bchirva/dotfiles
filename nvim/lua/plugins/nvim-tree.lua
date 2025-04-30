return {
	"kyazdani42/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	lazy = false,
	keys = {
		{ "<leader>sf", "<cmd>NvimTreeToggle<CR>", { noremap = true, silent = true }, desc = "Toggle NvimTree" },
		{ "<leader>sr", "<cmd>NvimTreeRefresh<CR>", { noremap = true, silent = true }, desc = "Refresh NvimTree" },
	},
	opts = {
		hijack_cursor = true,
		git = {
			enable = false,
		},
	},
}
