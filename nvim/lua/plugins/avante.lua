local avante = {
	"yetone/avante.nvim",
	event = "VeryLazy",
	version = false,

	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-telescope/telescope.nvim",
		"hrsh7th/nvim-cmp",
		"folke/snacks.nvim",
		"nvim-tree/nvim-web-devicons",
	},
    opts = {}
}

local openai_key = os.getenv("OPENAI_API_KEY")
if openai_key ~= nil then
	avante.opts.provider = "openai"
	return avante
end

return {}
