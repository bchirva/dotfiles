local Plug = vim.fn['plug#']

vim.call("plug#begin")

-- LSP
Plug ('neovim/nvim-lspconfig')
Plug ('hrsh7th/cmp-nvim-lsp')
Plug ('hrsh7th/cmp-path')
Plug ('hrsh7th/nvim-cmp')
Plug ('folke/trouble.nvim')                 -- Diagnostics
-- Plug ('simrat39/symbols-outline.nvim')      -- Tags
-- Syntax highlight
Plug ('nvim-treesitter/nvim-treesitter', { ['do'] = function() vim.call(":TSUpdate") end })
-- DAP
Plug ('mfussenegger/nvim-dap')              -- Debugging
Plug ('nvim-neotest/nvim-nio')              -- Dap-ui dependency
Plug ('rcarriga/nvim-dap-ui')               -- Debugging UI
-- Mason
Plug ('williamboman/mason.nvim')
Plug ('williamboman/mason-lspconfig.nvim')
-- Snippets
Plug ('hrsh7th/cmp-vsnip')
Plug ('hrsh7th/vim-vsnip')
-- UI components
Plug ('kyazdani42/nvim-tree.lua')           -- File management
Plug ('nvim-lualine/lualine.nvim')          -- Status line
Plug ('akinsho/bufferline.nvim')            -- Tabs/buffers topbar
Plug ('folke/which-key.nvim')                -- Keybindings popup
-- Themes
Plug ('kyazdani42/nvim-web-devicons')       -- Icons for new lua plugins
-- Utils
Plug ('windwp/nvim-autopairs')              -- Auto pair brackets, quotes, parantheses etc.
Plug ('numToStr/Comment.nvim')              -- Commenting
Plug ('folke/todo-comments.nvim')           -- Special comments highlight
Plug ('lewis6991/gitsigns.nvim')            -- Git integration
Plug ('norcalli/nvim-colorizer.lua')        -- Color preview
-- Other
Plug ('lervag/vimtex')                      -- LaTeX support
-- Telescope
Plug ('nvim-lua/plenary.nvim')
Plug ('nvim-telescope/telescope.nvim')

vim.call("plug#end")
