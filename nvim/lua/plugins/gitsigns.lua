return {
	"lewis6991/gitsigns.nvim",
	opts = {
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "-" },
			topdelete = { text = "-" },
			changedelete = { text = "~" },
			untracked = { text = "?" },
		},
		signs_staged = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "-" },
			topdelete = { text = "-" },
			changedelete = { text = "~" },
			untracked = { text = "?" },
		},
	},
	keys = {
		{ "<leader>gn", "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", desc = "Next hunk", { expr = true } },
		{ "<leader>gp", "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", desc = "Prev hunk", { expr = true } },
		{ "<leader>gv", "<cmd>Gitsigns preview_hunk<CR>", desc = "Preview hunk" },
		{ "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", mode = { "n", "v" }, desc = "Reset hunk" },
		{ "<leader>gs", "<cmd>Gitsigns stage_buffer<CR>", mode = { "n", "v" }, desc = "Stage buffer" },
		{ "<leader>gc", "<cmd>Gitsigns reset_buffer<CR>", desc = "Reset buffer" },
		{ "<leader>gw", "<cmd>Gitsigns toggle_current_line_blame<CR>", desc = "Blame line" },
		{ "<leader>gf", "<cmd>Gitsigns diffthis<CR>", desc = "Diff this" },
	},
}
