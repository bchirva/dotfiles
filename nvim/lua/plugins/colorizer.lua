return {
    "norcalli/nvim-colorizer.lua",
    config = function ()
        require("colorizer").setup({})

        vim.api.nvim_create_autocmd({"BufReadPost", "BufNewFile"}, {
            callback = function()
                vim.cmd("ColorizerAttachToBuffer")
            end
        })

        vim.keymap.set("n", "<leader>uc", function()
            vim.cmd("ColorizerToggle")
        end, {desc = "Colorizer"} )

    end
}
