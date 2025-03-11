return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        -- Automatically install LSPs and related tools to stdpath for Neovim
        -- Mason must be loaded before its dependents so we need to set it up here.
        -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
        { "williamboman/mason.nvim", opts = {} },
        "williamboman/mason-lspconfig.nvim", -- Configure the automatic setup of every language server we install.
        "hrsh7th/cmp-nvim-lsp",              -- Allows extra capabilities provided by nvim-cmp.
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

        -- Configure the automatic setup of every language server installed.
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls", -- lua language server.
                "gopls",  -- Golang language server.
                "pylsp",  -- Python language server protocol.
                "ts_ls",  -- Typescript language server.
                -- "html",   -- HTML LSP.
                -- "cssls", -- CSS LSP.
                -- "tailwindcss", -- Tailwind LSP.
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
                            },
                        },
                    })
                end,
            },
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
                map('gh', '<cmd>lua vim.lsp.buf.signature_help()<cr>', "Display function signature [h]elp")
                map('<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<cr>',
                    "Display function signature [h]elp", "i")
                map('<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', "LSP rename all instances")
                -- Execute a code action, usually your cursor needs to be on top of an error
                -- or a suggestion from your LSP for this to activate.
                map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
                map('<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', "")

                local client = vim.lsp.get_client_by_id(args.data.client_id)

                -- The following code creates a keymap to toggle inlay hints in your
                -- code, if the language server you are using supports them
                --
                -- This may be unwanted, since they displace some of your code
                if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                    map('<leader>th', function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = args.buf })
                    end, '[T]oggle Inlay [H]ints')
                end

                -- Format the file on save.
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
