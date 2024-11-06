return {
    "neovim/nvim-lspconfig",

    dependencies = {
        "williamboman/mason.nvim",           -- Will make sure we have access to the language servers.
        "williamboman/mason-lspconfig.nvim", -- Configure the automatic setup of every language server we install.

        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",

        "L3MON4D3/LuaSnip",
    },

    config = function()
        -- LSP servers and clients are able to communicate to each other what features they support.

        --  By default, Neovim doesn't support everything that is in the LSP specification.
        --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
        --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
        local capabilities = vim.tbl_deep_extend(
            'force',
            {},
            vim.lsp.protocol.make_client_capabilities(),
            require('cmp_nvim_lsp').default_capabilities()
        )

        local lspconfig = require("lspconfig")

        -- Use mason to fetch LSPs that are independent of any installed on the system.
        require("mason").setup({})
        -- Configure the automatic setup of every language server installed.
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "gopls",
            },
            handlers = {
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities,
                    })
                end,
                ["lua_ls"] = function()
                    -- configure lua server (with special settings)
                    lspconfig.lua_ls.setup({
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                -- make the language server recognize "vim" global
                                diagnostics = {
                                    globals = { "vim" },
                                },
                                completion = {
                                    callSnippet = "Replace",
                                },
                            },
                        },
                    })
                end,
                ["gopls"] = function()
                    lspconfig.gopls.setup({
                        root_dir = lspconfig.util.root_pattern(".git", "go.mod", "go.work"),
                        capabilities = capabilities,
                        cmd = { "gopls" },
                        filetypes = { "go", "gomod", "gowork", "gotmpl" },
                        inlay_hints = { enabled = true, },
                        settings = {
                            gopls = {
                                completeUnimported = true,
                                completeFunctionCalls = true,
                                usePlaceholders = false,
                                analyses = {
                                    unusedparams = true,
                                },
                                staticcheck = true,
                                gofumpt = false,
                                --hints = {
                                --    assignVariableTypes = true,
                                --    compositeLiteralFields = true,
                                --    compositeLiteralTypes = true,
                                --    constantValues = true,
                                --    functionTypeParameters = true,
                                --    parameterNames = true,
                                --    rangeVariableTypes = true,
                                --},
                            },
                        },
                    })
                end,
            },
        })

        -- Set up autocompletion.
        local cmp = require("cmp")

        cmp.setup({
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" }, -- snippets
                { name = "buffer" }, -- text within current buffer
                { name = "path" }, -- file system paths
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

        -- Automatic action performed on events.
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
            callback = function(args)
                -- NOTE: Remember that Lua is a real programming language, and as such it is possible
                -- to define small helper and utility functions so you don't have to repeat yourself.
                --
                -- In this case, we create a function that lets us more easily define mappings specific
                -- for LSP related items. It sets the mode, buffer and description for us each time.
                local map = function(keys, func, desc, mode)
                    mode = mode or 'n'
                    vim.keymap.set(mode, keys, func, { buffer = args.buf, desc = 'LSP: ' .. desc })
                end

                map('K', '<cmd>lua vim.lsp.buf.hover()<cr>', "[G]oto [D]efinition")
                map('gd', '<cmd>lua vim.lsp.buf.definition()<cr>', "[G]oto [D]efinition")
                map('gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', "[G]oto [D]eclaration")
                map('gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', "[G]oto [I]mplementation")
                map('go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', "Type [D]efinition")
                map('gr', '<cmd>lua vim.lsp.buf.references()<cr>', "[G]oto [R]eferences")
                map('gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', "")
                map('<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', "")
                -- Execute a code action, usually your cursor needs to be on top of an error
                -- or a suggestion from your LSP for this to activate.
                map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
                map('<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', "")

                local client = vim.lsp.get_client_by_id(args.data.client_id)

                if client.supports_method("textDocument/inlayHint") then
                    vim.lsp.inlay_hint.enable(true)
                end

                if client.supports_method("textDocument/formatting") then
                    -- Format the current buffer on save.
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = args.buf,
                        callback = function()
                            vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
                        end
                    })

                    -- Golang specific actions.
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        pattern = "*.go",
                        callback = function()
                            local params = vim.lsp.util.make_range_params()
                            params.context = { only = { "source.organizeImports" } }
                            -- buf_request_sync defaults to a 1000ms timeout. Depending on your
                            -- machine and codebase, you may want longer. Add an additional
                            -- argument after params if you find that you have to write the file
                            -- twice for changes to be saved.
                            -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
                            local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
                            for cid, res in pairs(result or {}) do
                                for _, r in pairs(res.result or {}) do
                                    if r.edit then
                                        local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                                        vim.lsp.util.apply_workspace_edit(r.edit, enc)
                                    end
                                end
                            end
                        end
                    })
                end
            end
        })
    end
}
