-- https://github.com/nvim-tree/nvim-tree.lua

return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    config = function()
        -- Disable netrw.
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        require("nvim-tree").setup({
            renderer = {
                indent_markers = {
                    enable = true,
                },
            },
            filters = {
                custom = {
                    ".DS_Store",
                    "^.git$",
                    "^.vscode$",
                },
            },
            git = {
                ignore = false, -- This will show .env file in tree.
            },
        })

        vim.keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>",
            { desc = "Toggle file [e]xplorer" })                   -- toggle file explorer
        vim.keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>",
            { desc = "Toggle file [e]xplorer on [c]urrent file" }) -- toggle file explorer on current file
        vim.keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>",
            { desc = "Collapse file explorer" })                   -- collapse file explorer
        vim.keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>",
            { desc = "Refresh file explorer" })                    -- refresh file explorer
    end,
}
