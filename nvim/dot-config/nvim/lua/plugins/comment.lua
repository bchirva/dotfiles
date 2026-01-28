return {
	"numToStr/Comment.nvim",
	opts = {
		mappings = {
			basic = true,
			extra = false,
		},
		toggler = {
			line = "<leader>ccl",
			block = "<leader>ccb",
		},
		opleader = {
			line = "<leader>cl",
			block = "<leader>cb",
		},
	},
}

-- vim.keymap.set('n', '<leader>cl', '<Plug>(comment_toggle_current_linewise)', {noremap = true, silent = false})
-- vim.keymap.set('n', '<leader>cb', '<Plug>(comment_toggle_current_blockwise)', {noremap = true, silent = false})
-- vim.keymap.set('x', '<leader>cl', '<Plug>(comment_toggle_linewise_visual)', {noremap = true, silent = false})
-- vim.keymap.set('x', '<leader>cb', '<Plug>(comment_toggle_blockwise_visual)', {noremap = true, silent = false})
