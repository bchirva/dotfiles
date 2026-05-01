vim.pack.add({
    "https://github.com/mfussenegger/nvim-dap",
    "https://github.com/rcarriga/nvim-dap-ui",
    "https://github.com/nvim-neotest/nvim-nio"
})

local dap = require("dap")
local dapui = require("dapui")

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

for name, type in vim.fs.dir(vim.fn.stdpath("config") .. "/lua/dap") do
  if type == "file" and name:match("%.lua$") then
    require("dap." .. name:gsub("%.lua$", ""))
  end
end

vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP breakpoint" })
vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "DAP continue" })
vim.keymap.set("n", "<leader>dn", dap.step_over, { desc = "DAP step over" })
vim.keymap.set("n", "<leader>dp", dap.step_back, { desc = "DAP step back" })
vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "DAP step out" })
vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "DAP step out" })
vim.keymap.set("n", "<leader>dx", "<cmd>DapTerminate<CR>", { desc = "DAP terminate" })
vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "DAP toggle UI" })

-- local pickers = require("telescope.pickers")
-- local finders = require("telescope.finders")
-- local sorters = require("telescope.sorters")
-- local actions = require("telescope.actions")
-- local action_state = require("telescope.actions.state")
-- local Path = require("plenary.path")

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "ErrorMsg", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "WarningMsg", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "", texthl = "Question", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "󰜺", texthl = "Error", linehl = "", numhl = "" })
