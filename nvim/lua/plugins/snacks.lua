return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		indent = { enabled = true },
		input = { enabled = true },
		scroll = { enabled = true },
		image = { enabled = true },
		lazygit = { enabled = true },
		notifier = { enabled = true },
	},
	keys = {
		{
			"<leader>gl",
			function()
				Snacks.lazygit()
			end,
			desc = "Lazygit",
		},
		{
			"<leader>uh",
			function()
				Snacks.notifier.show_history()
			end,
			desc = "Show notification history",
		},
		{
			"<leader>ui",
			function()
				Snacks.picker.icons()
			end,
			desc = "Icons picker",
		},
	},
}
