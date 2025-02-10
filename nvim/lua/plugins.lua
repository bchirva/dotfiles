local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
    -- LSP
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/nvim-cmp' },
    { 'folke/trouble.nvim' },     -- Diagnostics
    -- Linting & formatting
    { 'mfussenegger/nvim-lint' }, -- Linting
    { 'stevearc/conform.nvim' },  -- Formatting
    -- Syntax highlight
    { 'nvim-treesitter/nvim-treesitter',  build = ":TSUpdate" },
    -- DAP
    { 'mfussenegger/nvim-dap' }, -- Debugging
    { 'nvim-neotest/nvim-nio' }, -- Dap-ui dependency
    { 'rcarriga/nvim-dap-ui' },  -- Debugging UI
    -- Mason
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
    -- Snippets
    { 'hrsh7th/cmp-vsnip' },
    { 'hrsh7th/vim-vsnip' },
    -- UI components
    { 'kyazdani42/nvim-tree.lua' },     -- File management
    { 'nvim-lualine/lualine.nvim' },    -- Status line
    { 'akinsho/bufferline.nvim' },      -- Tabs/buffers topbar
    { 'folke/which-key.nvim' },         -- Keybindings popup
    -- Themes
    { 'kyazdani42/nvim-web-devicons' }, -- Icons for new lua plugins
    -- Utils
    { 'windwp/nvim-autopairs' },        -- Auto pair brackets, quotes, parantheses etc.
    { 'windwp/nvim-ts-autotag' },       -- Auto pair html tags
    { 'numToStr/Comment.nvim' },        -- Commenting
    { 'folke/todo-comments.nvim' },     -- Special comments highlight
    { 'lewis6991/gitsigns.nvim' },      -- Git integration
    { 'norcalli/nvim-colorizer.lua' },  -- Color preview
    -- Other
    { 'lervag/vimtex' },                -- LaTeX support
    { 'OXY2DEV/markview.nvim' },        -- Markdown pseudo-preview
    -- Telescope
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-telescope/telescope.nvim' },
})

-- Plugins settings
require("plugins/autocomplete")
require("plugins/autopairs")
require("plugins/autotags")
require("plugins/bufferline")
require("plugins/colorizer")
require("plugins/comment")
require("plugins/conform")
require("plugins/dap")
require("plugins/gitsigns")
require("plugins/lint")
require("plugins/lspconfig")
require("plugins/lualine")
require("plugins/mason")
require("plugins/nvim_tree")
require("plugins/telescope")
require("plugins/todo_comments")
require("plugins/treesitter")
require("plugins/trouble")
require("plugins/vimtex")
require("plugins/markview")
require("plugins/which_key")
