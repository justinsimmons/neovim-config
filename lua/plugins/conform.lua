return {
    'stevearc/conform.nvim',
    event = { "BufWritePre" },
    opts = {
        formatters_by_ft = {
            go = { "goimports", "gofmt", lsp_format = "fallback" },
            javascript = { "prettier" },
            typescript = { "prettier" },
            javascriptreact = { "prettier" },
            typescriptreact = { "prettier" },
            svelte = { "prettier" },
            css = { "prettier" },
            html = { "prettier" },
            json = { "prettier" },
            yaml = { "prettier" },
            markdown = { "prettier" },
            --lua = { "stylua" },
            --python = { "isort", "black" },
        },
        format_on_save = {
            lsp_fallback = true,
            async = false,
            timeout_ms = 1000,
        },
        -- Conform will notify you when a formatter errors
        notify_on_error = true,
    },
}
