return {
	"kyazdani42/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	lazy = false,
	keys = {
		{ "<leader>sf", "<cmd>NvimTreeToggle<CR>", { noremap = true, silent = true }, desc = "NvimTree" },
	},
	opts = {
		hijack_cursor = true,
		git = {
			enable = false,
		},
	},
}
