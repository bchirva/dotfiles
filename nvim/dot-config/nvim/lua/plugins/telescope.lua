return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {},
	keys = {
		{ "<leader>ff", require("telescope.builtin").find_files, desc = "Find files" },
		{ "<leader>fg", require("telescope.builtin").live_grep, desc = "Find text via grep" },
		{ "<leader>fb", require("telescope.builtin").buffers, desc = "Find buffer" },
		{ "<leader>fh", require("telescope.builtin").help_tags, desc = "Help tags" },
		{ "<leader>lu", "<cmd>Telescope lsp_references<CR>", desc = "LSP references" },
	},
}

-- telescope.setup {
--     defaults = {
--         mappings = {
--             i = {
--                 -- map actions.which_key to <C-h> (default: <C-/>)
--                 -- actions.which_key shows the mappings for your picker,
--                 -- e.g. git_{create, delete, ...}_branch for the git_branches picker
--                 ["<C-h>"] = "which_key"
--             }
--         }
--     },
--     pickers = {},
--     extensions = {}
-- }
