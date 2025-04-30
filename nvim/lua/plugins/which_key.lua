return {
	"folke/which-key.nvim",
	dependencies = {
		"kyazdani42/nvim-web-devicons",
	},
	lazy = false,
	keys = {
		{ "<leader>?", "<cmd>WhichKey<CR>", desc = "WhichKey" },
		{ "<C-l>", "<C-w><C-l>" },
		{ "<C-j>", "<C-w><C-j>" },
		{ "<C-h>", "<C-w><C-h>" },
		{ "<C-k>", "<C-w><C-k>" },
		{ "<leader>s.", "<cmd>vertical resize +10<CR>" },
		{ "<leader>s,", "<cmd>vertical resize -10<CR>" },
		{ "<leader>s=", "<cmd>resize +10<CR>" },
		{ "<leader>s-", "<cmd>resize -10<CR>" },
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
		local opts = { noremap = true, silent = true }

		local which_key = require("which-key")

		which_key.add({
			{ "<leader>nh", desc = "No highlight" },
			{ "<leader>c", group = "Comment..." },

			{ "<leader>b", group = "Buffers..." },
			{ "<leader>d", group = "DAP..." },
			{ "<leader>l", group = "LSP..." },
			{ "<leader>f", group = "Telescope..." },

			{ "<leader>g", group = "Git..." },
			-- { "<leader>gc", desc = "Reset buffer" },
			-- { "<leader>gf", desc = "Diff" },
			-- { "<leader>gn", desc = "Next hunk" },
			-- { "<leader>gp", desc = "Prev hunk" },
			-- { "<leader>gr", desc = "Reset hunk" },
			-- { "<leader>gs", desc = "Stage buffer" },
			-- { "<leader>gv", desc = "Preview hunk" },
			-- { "<leader>gw", desc = "Blame" },

			{ "<leader>s", group = "Splits..." },
			{ "<leader>t", group = "Tabs..." },
		})
	end,
}
