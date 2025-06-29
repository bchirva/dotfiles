return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
	},

	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		--
		-- local pickers = require("telescope.pickers")
		-- local finders = require("telescope.finders")
		-- local sorters = require("telescope.sorters")
		-- local actions = require("telescope.actions")
		-- local action_state = require("telescope.actions.state")
		-- local Path = require("plenary.path")

		dapui.setup()

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		dap.adapters.lldb = {
			type = "executable",
			command = "/usr/bin/lldb-dap",
			name = "lldb",
		}

		dap.adapters.python = function(cb, config)
			if config.request == "attach" then
				local port = (config.connect or config).port
				local host = (config.connect or config).host or "127.0.0.1"
				cb({
					type = "server",
					port = assert(port, "`connect.port` is required for a python `attach` configuration"),
					host = host,
					options = {
						source_filetype = "python",
					},
				})
			else
				cb({
					type = "executable",
					command = vim.fn.expand("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"),
					args = { "-m", "debugpy.adapter" },
					options = {
						source_filetype = "python",
					},
				})
			end
		end

		dap.configurations.c = {
			(function()
				local exe_path
				return {
					name = "Launch",
					type = "lldb",
					request = "launch",
					program = function()
						exe_path = vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
						return exe_path
					end,
					cwd = function()
						if exe_path then
							return vim.fn.fnamemodify(exe_path, ":p:h")
						else
							return vim.fn.getcwd()
						end
					end,
					stopOnEntry = false,
					args = {},
				}
			end)(),
		}

		dap.configurations.cpp = dap.configurations.c
		dap.configurations.rust = dap.configurations.c

		dap.configurations.python = {
			{
				type = "python",
				request = "launch",
				name = "Launch current file",

				program = "${file}",
				pythonPath = function()
					local venv = os.getenv("VIRTUAL_ENV")
					if venv then
						return venv .. "/bin/python"
					else
						return "/usr/bin/python"
					end
				end,
			},
			{
				type = "python",
				request = "launch",
				name = "Launch module",
				module = function()
					return vim.fn.input("Module name: ")
				end,
				pythonPath = function()
					local venv = os.getenv("VIRTUAL_ENV")
					if venv then
						return venv .. "/bin/python"
					else
						return "/usr/bin/python"
					end
				end,
			},
		}

		vim.keymap.set("n", "<leader>db", function()
			dap.toggle_breakpoint()
		end, { desc = "DAP breakpoint" })
		vim.keymap.set("n", "<leader>dc", function()
			dap.continue()
		end, { desc = "DAP continue" })
		vim.keymap.set("n", "<leader>dn", function()
			dap.step_over()
		end, { desc = "DAP step over" })
		vim.keymap.set("n", "<leader>dp", function()
			dap.step_back()
		end, { desc = "DAP step back" })
		vim.keymap.set("n", "<leader>do", function()
			dap.step_out()
		end, { desc = "DAP step out" })
		vim.keymap.set("n", "<leader>di", function()
			dap.step_into()
		end, { desc = "DAP step out" })
		vim.keymap.set("n", "<leader>dx", "<cmd>DapTerminate<CR>", { desc = "DAP terminate" })
		vim.keymap.set("n", "<leader>du", function()
			dapui.toggle()
		end, { desc = "DAP toggle UI" })
	end,
}
