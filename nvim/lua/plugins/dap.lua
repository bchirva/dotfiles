local dap = require("dap")
local dapui = require("dapui")

dapui.setup({})

local bufopts = { noremap=true, silent=true, buffer=bufnr }
vim.keymap.set('n', '<leader>dt', dap.toggle_breakpoint, bufopts)
vim.keymap.set('n', '<leader>dc', dap.continue, bufopts)
vim.keymap.set('n', '<leader>dn', dap.step_over, bufopts)
vim.keymap.set('n', '<leader>dp', dap.step_back, bufopts)
vim.keymap.set('n', '<leader>do', dap.step_out, bufopts)
vim.keymap.set('n', '<leader>di', dap.step_into, bufopts)
vim.keymap.set('n', '<leader>du', dapui.toggle, bufopts)

dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode',
  name = 'lldb'
}

dap.configurations.c = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
  },
}
dap.configurations.cpp = dap.configurations.c

