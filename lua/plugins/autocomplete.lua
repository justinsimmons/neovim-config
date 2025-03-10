return {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
        {
            "L3MON4D3/LuaSnip",
            --lazy = true,
            -- follow latest release.
            version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
            -- install jsregexp (optional!).
            build = "make install_jsregexp",
            dependencies = {
                "saadparwaiz1/cmp_luasnip",
                {
                    "rafamadriz/friendly-snippets",
                    config = function()
                        require("luasnip.loaders.from_vscode").lazy_load()
                    end
                },
            },
        },
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
    },
    config = function()
        -- Set up autocompletion.
        local cmp = require("cmp")
        local luasnip = require("luasnip")

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" }, -- snippets
                { name = "buffer" },  -- text within current buffer
                { name = "path" },    -- file system paths
            }),
            mapping = cmp.mapping.preset.insert({
                -- Navigate between completion items
                ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
                ['<C-n>'] = cmp.mapping.select_next_item({ behavior = 'select' }),

                -- `Enter` key to confirm completion
                ['<CR>'] = cmp.mapping.confirm({ select = false }),

                -- Ctrl+Space to trigger completion menu
                ['<C-Space>'] = cmp.mapping.complete(),

                -- Scroll up and down in the completion documentation
                ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                ['<C-d>'] = cmp.mapping.scroll_docs(4),
            }),
        })
    end
}
