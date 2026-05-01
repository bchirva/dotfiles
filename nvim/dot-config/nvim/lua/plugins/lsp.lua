vim.pack.add({
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/hrsh7th/nvim-cmp",
    "https://github.com/hrsh7th/cmp-nvim-lsp",
    "https://github.com/hrsh7th/cmp-path",
    "https://github.com/hrsh7th/cmp-vsnip",
    "https://github.com/hrsh7th/vim-vsnip",
})

local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    sources = cmp.config.sources({
        { name = "nvim-lsp-signature-help" },
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "vsnip" },
    }),
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
        ["<C-l>"] = cmp.mapping.scroll_docs(-4),
        ["<C-h>"] = cmp.mapping.scroll_docs(4),

        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-a>"] = cmp.mapping.abort(),
    }),
})

vim.lsp.config("*", {
    capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
})

vim.lsp.enable({ "clangd", "pyright", "lua_ls", "bashls", "ts_ls", "cssls" })

vim.keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, { desc = "LSP go to declaration" })
vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, { desc = "LSP go to definition" })
vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, { desc = "LSP hover" })
vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, { desc = "LSP implementation" })
vim.keymap.set("n", "<leader>lt", vim.lsp.buf.type_definition, { desc = "LSP type definition" })
vim.keymap.set("n", "<leader>lc", vim.lsp.buf.rename, { desc = "LSP rename" })
vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { desc = "LSP code action" })
vim.keymap.set("n", "<leader>ls", vim.lsp.buf.signature_help, { desc = "LSP signature help" })

vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.INFO] = " ",
            [vim.diagnostic.severity.HINT] = "󰅺",
        },
    },
})

require("theme/highlight").set(
    {
        CmpItemMenu = {},
        CmpItemAbbrMatch = { bold = true },
        CmpItemAbbrMatchFuzzy = { bold = true, italic = true },
        CmpItemKindText = { link = "String" },

        CmpItemKindField = { link = "Identifier" },
        CmpItemKindProperty = { link = "Identifier" },
        CmpItemKindValue = { link = "Identifier" },
        CmpItemKindVariable = { link = "Identifier" },
        CmpItemKindEnumMember = { link = "Identifier" },
        CmpItemKindReference = { link = "Identifier" },

        CmpItemKindClass = { link = "Structure" },
        CmpItemKindEnum = { link = "Structure" },
        CmpItemKindInterface = { link = "Structure" },
        CmpItemKindStruct = { link = "Structure" },

        CmpItemKindFile = { link = "PreProc" },
        CmpItemKindFolder = { link = "PreProc" },
        CmpItemKindModule = { link = "PreProc" },
        CmpItemKindUnit = { link = "PreProc" },

        CmpItemKindConstructor = { link = "Function" },
        CmpItemKindEvent = { link = "Function" },
        CmpItemKindFunction = { link = "Function" },
        CmpItemKindMethod = { link = "Function" },

        CmpItemAbbr = { link = "Tag" },
        CmpItemAbbrDeprecated = { strikethrough = true },
        CmpItemKindConstant = { link = "Constant" },
        CmpItemKindOperator = { link = "Operator" },
        CmpItemKindKeyword = { link = "Keyword" },
        CmpItemKindColor = { link = "Special" },
        CmpItemKindSnippet = { link = "Special" },
        CmpItemKindTypeParameter = { link = "Typedef" },
    }
)
