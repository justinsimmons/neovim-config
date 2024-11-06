return {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {
        indent = { char = "┊" },
        scope = {
            show_start = false,
            show_end = false,
            show_exact_scope = false,
        }
    },
}
