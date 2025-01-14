-- https://github.com/tpope/vim-fugitive

return {
    "tpope/vim-fugitive",
    event = { "VeryLazy" },
    config = function()
        vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
    end
}
