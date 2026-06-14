vim.pack.add({ "https://github.com/orjangj/neotest-ctest" })

return require("neotest-ctest").setup({
    dap_adapter = "lldb-dap",
    is_test_file = function(file_path)
        local name = vim.fn.fnamemodify(file_path, ":t")
        local ext = vim.fn.fnamemodify(file_path, ":e")
        return (ext == "cpp" or ext == "cc" or ext == "cxx")
            and (vim.endswith(name, "_test") or vim.startswith(name, "test_"))
    end,
})
