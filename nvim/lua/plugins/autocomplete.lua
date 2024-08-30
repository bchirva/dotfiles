vim.opt.completeopt = {"menu", "menuone", "noselect", "preview"}

local cmp = require("cmp")

cmp.setup ({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end
    },
    sources = cmp.config.sources({
        { name = 'nvim-lsp-signature-help'},
        { name = 'nvim_lsp' },
        { name = 'path' },
        { name = 'vsnip' }
    }),
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered()
    },
    mapping = cmp.mapping.preset.insert ({
        ["<C-j>"] =     cmp.mapping.select_next_item(),
        ["<C-k>"] =     cmp.mapping.select_prev_item(),
        ["<Tab>"] =     cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
        ["<S-Tab>"] =   cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
        ["<C-l>"] =     cmp.mapping.scroll_docs(-4),
        ["<C-h>"] =     cmp.mapping.scroll_docs(4),

        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] =      cmp.mapping.confirm( { select = true } ),
        ['<C-a>'] =     cmp.mapping.abort()
    })
})
