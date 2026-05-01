local dap = require("dap")

dap.adapters.lldb = {
    type = "executable",
    command = "/usr/bin/lldb-dap",
    name = "lldb",
}

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
