vim.pack.add({ "https://github.com/folke/todo-comments.nvim" })

require("todo-comments").setup()

vim.keymap.set("n", "<leader>fc", "<cmd>TodoTelescope<CR>", { desc = "Find comments" })
vim.keymap.set("n", "<leader>sc", "<cmd>Trouble todo toggle<CR>", { desc = "TODO comments" })
