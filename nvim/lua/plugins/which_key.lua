return {
	"folke/which-key.nvim",
	dependencies = {
		"kyazdani42/nvim-web-devicons",
	},
	lazy = false,
	keys = {
		{ "<leader>?", "<cmd>WhichKey<CR>", desc = "WhichKey" },
		{ "<C-l>", "<cmd>wincmd l<CR>" },
		{ "<C-j>", "<cmd>wincmd j<CR>" },
		{ "<C-h>", "<cmd>wincmd h<CR>" },
		{ "<C-k>", "<cmd>wincmd k<CR>" },
		{ "<Esc>l", "<cmd>vertical resize +10<CR>" },
		{ "<Esc>h", "<cmd>vertical resize -10<CR>" },
		{ "<Esc>j", "<cmd>resize +10<CR>" },
		{ "<Esc>k", "<cmd>resize -10<CR>" },
		{ "<leader>to", "<cmd>tabnew<CR>", desc = "New tab" },
		{ "<leader>tn", "<cmd>tabnext<CR>", desc = "Next tab" },
		{ "<leader>tp", "<cmd>tabprevious<CR>", desc = "Prev tab" },
		{ "<leader>tc", "<cmd>tabclose<CR>", desc = "Close tab" },
		{ "<leader>sv", "<cmd>vsplit<CR>", desc = "Vertical split" },
		{ "<leader>sh", "<cmd>split<CR>", desc = "Horizontal split" },
		{ "<leader>bn", "<cmd>bnext<CR>", desc = "Next buffer" },
		{ "<leader>bp", "<cmd>bprev<CR>", desc = "Prev buffer" },
		{ "<leader>bc", "<cmd>BufferLinePick<CR>", desc = "Pick buffer" },
		{ "<Tab>", "<cmd>bnext<CR>", desc = "Next buffer" },
		{ "<S-Tab>", "<cmd>bprev<CR>", desc = "Prev buffer" },
		{ "<leader>nh", ":nohlsearch<CR>", desc = "Reset highlight" },
	},
	config = function()
		local which_key = require("which-key")

		which_key.setup({
			win = {
				border = "rounded",
			},
		})

		which_key.add({
			{ "<leader>nh", desc = "No highlight" },
			{ "<leader>c", group = "Comment..." },
			{ "<leader>b", group = "Buffers..." },
			{ "<leader>d", group = "DAP..." },
			{ "<leader>l", group = "LSP..." },
			{ "<leader>f", group = "Telescope..." },
			{ "<leader>g", group = "Git..." },
			{ "<leader>s", group = "Splits..." },
			{ "<leader>t", group = "Tabs..." },
			{ "<leader>q", group = "Tests..." },
			{ "<leader>u", group = "Utilities..." },
		})
	end,
}
