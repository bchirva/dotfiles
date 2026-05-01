local dap = require("dap")

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

