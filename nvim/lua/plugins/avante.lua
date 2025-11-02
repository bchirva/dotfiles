return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	version = false,
	build = "make",

	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-telescope/telescope.nvim",
		"hrsh7th/nvim-cmp",
		"folke/snacks.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		mode = "legacy",
		provider = "ollama",
		auto_suggestions_provider = "ollama",
		providers = {
			ollama = {
				disable_tools = true,
				endpoint = "http://127.0.0.1:11434",
				model = "qwen2.5-coder:7b",
				is_env_set = function()
					local pgrep = vim.system({ "pgrep", "ollama" }):wait()
					if pgrep.code ~= 0 then
						return false
					end

					local curl = vim.system({ "curl", "-sSf", "http://127.0.0.1:11434/api/tags" }, { text = true })
						:wait()
					return curl.code == 0
				end,
			},
			openai = {
				is_env_set = function()
					return false
				end,
			},
			claude = {
				is_env_set = function()
					return false
				end,
			},
			vertex = {
				is_env_set = function()
					return false
				end,
			},
			vertex_claude = {
				is_env_set = function()
					return false
				end,
			},
			gemini = {
				is_env_set = function()
					return false
				end,
			},
			copilot = {
				is_env_set = function()
					return false
				end,
			},
		},
		input = {
			provider = "snacks",
			provider_opts = {
				title = "Avante Input",
				icon = " ",
			},
		},
	},
}
