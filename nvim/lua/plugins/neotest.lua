return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		-- Adapters --
		"alfaix/neotest-gtest",
		"nvim-neotest/neotest-python",
	},
	config = function()
		local neotest = require("neotest")

		neotest.setup({
			adapters = {
				require("neotest-python")({
					python = function()
						local venv = os.getenv("VIRTUAL_ENV")
						if venv then
							return venv .. "/bin/python"
						else
							return "/usr/bin/python"
						end
					end,
				}),
				require("neotest-gtest").setup({
					debug_adapter = "lldb",
				}),
			},
		})

		vim.keymap.set("n", "<leader>st", neotest.summary.toggle, { desc = "Neotest summary" })
		vim.keymap.set("n", "<leader>qs", function()
			neotest.run.run({ suite = true })
		end, { desc = "Run test suite" })
		vim.keymap.set("n", "<leader>qn", function()
			neotest.run.run()
		end, { desc = "Run nearest test" })
		vim.keymap.set("n", "<leader>qd", function()
			neotest.run.run({ strategy = "dap" })
		end, { desc = "Debug nearest test" })
		vim.keymap.set("n", "<leader>qf", function()
			neotest.run.run(vim.fn.expand("%"))
		end, { desc = "Run tests in file" })
		vim.keymap.set("n", "<leader>qa", function()
			neotest.run.run(vim.fn.getcwd())
		end, { desc = "Run all tests in CWD" })
	end,
}
