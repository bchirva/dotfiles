return {
	"folke/trouble.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	cmd = "Trouble",
	keys = {
		{ "<leader>sd", "<cmd>Trouble diagnostics toggle<CR>", desc = "Trouble diagnostics" },
		{ "<leader>ss", "<cmd>Trouble symbols toggle focus=true<CR>", desc = "Trouble symbols" },
		{ "<leader>sl", "<cmd>Trouble lsp toggle<CR>", desc = "Trouble LSP" },
	},
	config = function()
		require("trouble").setup()

		local signs = { Error = " ", Warn = " ", Info = " ", Hint = "󰅺" }
		-- local signs = { Error = " ", Warn = " ", Info = " ", Hint = "" }

		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
		end
	end,
}
