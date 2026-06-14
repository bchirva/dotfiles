vim.pack.add({
    "https://github.com/nvim-neotest/neotest",
    -- dependencies --
    "https://github.com/antoinemadec/FixCursorHold.nvim",
})

local test_adapters = {}
for name, type in vim.fs.dir(vim.fn.stdpath("config") .. "/lua/tests") do
    if type == "file" and name:match("%.lua$") then
        table.insert(test_adapters, require("tests." .. name:gsub("%.lua$", "")))
    end
end

local neotest = require("neotest")
neotest.setup({
    adapters = test_adapters
})

vim.keymap.set("n", "<leader>sq", "<cmd>Neotest summary<cr>", { desc = "Neotest" })
vim.keymap.set("n", "<leader>qr", function() neotest.run.run({ suite = true }) end, { desc = "Run test suite" })
vim.keymap.set("n", "<leader>qR", function() neotest.run.run(vim.fn.expand("%")) end, { desc = "Run this test" })
vim.keymap.set("n", "<leader>qd", function() neotest.run.run({ vim.fn.expand("%"), strategy = "dap" }) end,
    { desc = "Debug this test" })
vim.keymap.set("n", "<leader>qq", function() neotest.run.stop() end, { desc = "Stop test" })
vim.keymap.set("n", "<leader>qs", function() neotest.output_panel.toggle() end, { desc = "Test output" })
