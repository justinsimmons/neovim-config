-- https://github.com/mbbill/undotree
--
return {
    "mbbill/undotree",
    event = "VeryLazy",

    config = function()
        vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
    end
}
