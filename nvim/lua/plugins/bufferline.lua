local lualine = require("bufferline")

lualine.setup {
    options = {
        -- mode = "tabs",
        mode = "buffers",
        offsets = {{filetype = "NvimTree", text = "File Explorer"}}
    },
}
