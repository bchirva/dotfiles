vim.pack.add({
    "https://github.com/nvim-neotest/neotest",
    -- dependencies --
    "https://github.com/antoinemadec/FixCursorHold.nvim",
})

local neotest = require("neotest")
neotest.setup({})

for name, type in vim.fs.dir(vim.fn.stdpath("config") .. "/lua/tests") do
    if type == "file" and name:match("%.lua$") then
        require("tests." .. name:gsub("%.lua$", ""))
    end
end

vim.keymap.set("n", "<leader>sq", "<cmd>Neotest summary<cr>", { desc = "Neotest" })
-- vim.keymap.set("n", "<leader>qr", neotest.run.run(), { desc = "Run nearest test" })
-- vim.keymap.set("n", "<leader>qR", neotest.run.run(vim.fn.expand("%")), { desc = "Run this test" })
-- vim.keymap.set("n", "<leader>qD", neotest.run.run({vim.fn.expand("%"), strategy = "dap"}), { desc = "Debug this test" })
-- vim.keymap.set("n", "<leader>qs", neotest.run.stop(), { desc = "Stop test" })
