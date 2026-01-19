return {
	"MeanderingProgrammer/render-markdown.nvim",
	opts = {
		file_types = { "markdown", "Avante" },
		heading = {
			icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
		},
		bullet = {
			icons = { " ", " ", " ", " " },
		},
		checkbox = {
			unchecked = {
				icon = "󰄱 ",
			},
			checked = {
				icon = "󰄲 ",
			},
		},
	},
    keys = {
		{ "<leader>um", "<cmd>RenderMarkdown toggle<CR>", desc = "Render markdown" },
    },
	ft = { "markdown", "Avante" },
}
