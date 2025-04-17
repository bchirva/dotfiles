local dap = require("dap")
local dapui = require("dapui")

dapui.setup({})

local bufopts = { noremap = true, silent = true, buffer = bufnr }
vim.keymap.set('n', '<leader>dt', dap.toggle_breakpoint, bufopts)
vim.keymap.set('n', '<leader>dc', dap.continue, bufopts)
vim.keymap.set('n', '<leader>dn', dap.step_over, bufopts)
vim.keymap.set('n', '<leader>dp', dap.step_back, bufopts)
vim.keymap.set('n', '<leader>do', dap.step_out, bufopts)
vim.keymap.set('n', '<leader>di', dap.step_into, bufopts)
vim.keymap.set('n', '<leader>du', dapui.toggle, bufopts)

dap.adapters.lldb = {
    type = 'executable',
    command = '/usr/bin/lldb-dap',
    name = 'lldb'
}

dap.adapters.python = function(cb, config)
    if config.request == 'attach' then
        local port = (config.connect or config).port
        local host = (config.connect or config).host or '127.0.0.1'
        cb({
            type = 'server',
            port = assert(port, '`connect.port` is required for a python `attach` configuration'),
            host = host,
            options = {
                source_filetype = 'python',
            },
        })
    else
        cb({
            type = 'executable',
            command = '~/.local/share/nvim/mason/packages/debugpy/venv/bin/python',
            args = { '-m', 'debugpy.adapter' },
            options = {
                source_filetype = 'python',
            },
        })
    end
end

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
dap.configurations.rust = dap.configurations.c

dap.configurations.python = {
    {
        type = 'python',
        request = 'launch',
        name = "Launch file",

        program = "${file}",
        pythonPath = function()
            local venv = os.getenv("VIRTUAL_ENV")
            if venv then
                return venv .. "/python"
            else
                return "/usr/bin/python"
            end
        end,
    },
}
