vim.pack.add({"https://github.com/akinsho/bufferline.nvim"})

require("bufferline").setup({
    options = {
        mode = "buffers",
        offsets = { { filetype = "NvimTree", text = "File Explorer" } },
    }
})
