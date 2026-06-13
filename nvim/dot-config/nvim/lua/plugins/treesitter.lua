vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })

local treesitter = require("nvim-treesitter")
treesitter.setup({
    install_dir = vim.fn.stdpath("data") .. "/site"
})

treesitter.install({
    "cpp",
    "python",
    "bash",
})

vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        if ev.data.spec.name == "nvim-treesitter"
            and ev.data.kind == "update" then
            if not ev.data.active then
                vim.cmd.packadd("nvim-treesitter")
            end
            vim.cmd.TSUpdate()
        end
    end,
})
