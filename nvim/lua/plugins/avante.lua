
local is_ollama_running = os.execute("pgrep ollama > /dev/null") == 0
if is_ollama_running then
    return {
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
        opts = {
            provider = "ollama",
            input = {
                provider = "snacks",
                provider_opts = {
                    title = "Avante Input",
                    icon = " ",
                },
            },
        },
    }
else
    return {}
end

