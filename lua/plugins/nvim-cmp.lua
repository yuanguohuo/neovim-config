local function cmp_config()
    local cmp = require'cmp'

    local jump_to_next = function(fallback)
        if vim.fn["vsnip#jumpable"](1) == 1 then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Plug>(vsnip-jump-next)', true, true, true), '', true)
        elseif cmp.visible() then
            cmp.select_next_item()
        else
            fallback()
        end
    end

    local jump_to_prev = function(fallback)
        if vim.fn["vsnip#jumpable"](-1) == 1 then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Plug>(vsnip-jump-prev)', true, true, true), '', true)
        elseif cmp.visible() then
            cmp.select_prev_item()
        else
            fallback()
        end
    end

    cmp.setup({
        snippet = {
            -- REQUIRED - you must specify a snippet engine
            expand = function(args)
                vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
            end,
        },
        window = {
            -- completion = cmp.config.window.bordered(),
            -- documentation = cmp.config.window.bordered(),
        },

        mapping = cmp.mapping.preset.insert({
            ['<C-b>']     = cmp.mapping.scroll_docs(-4),
            ['<C-f>']     = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<CR>']      = cmp.mapping.confirm({select = true}), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            ['<C-e>']     = cmp.mapping.abort(),
            ['<ESC>']     = cmp.mapping.abort(),
            ["<Tab>"]     = cmp.mapping(jump_to_next, {"i", "s"}),
            ["<C-n>"]     = cmp.mapping(jump_to_next, {"i", "s"}),
            ["<C-p>"]     = cmp.mapping(jump_to_prev, {"i", "s"}),
        }),

        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'vsnip' }, -- For vsnip users.
            -- { name = 'luasnip' }, -- For luasnip users.
            -- { name = 'ultisnips' }, -- For ultisnips users.
            -- { name = 'snippy' }, -- For snippy users.
        }, {
            { name = 'buffer' },
        })
    })

    -- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
    -- Set configuration for specific filetype.
    --[[ cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
            { name = 'git' },
        }, {
            { name = 'buffer' },
        })
    })
    require("cmp_git").setup() ]]--

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = 'buffer' }
        }
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = 'path' }
        }, {
            { name = 'cmdline' }
        }),
        matching = { disallow_symbol_nonprefix_matching = false }
    })
end

return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "neovim/nvim-lspconfig",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",

        -- chose vsnip as our snippet engine

        -- For vsnip users
        "hrsh7th/cmp-vsnip",
        "hrsh7th/vim-vsnip",

        -- For luasnip users.
        -- "L3MON4D3/LuaSnip",
        -- "saadparwaiz1/cmp_luasnip",

        -- For ultisnips users.
        -- "SirVer/ultisnips",
        -- "quangnguyen30192/cmp-nvim-ultisnips",
    },
    config = cmp_config,
}
