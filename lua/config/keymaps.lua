vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Go to the [P]evious [v]iew" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Paste without deleting whats in buffer.
vim.keymap.set("x", "<leader>p", [["_dP]],
    { desc = "[P]aste without deleting buffer contents" })

-- Copy to system clipboard.
-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Window Management
vim.keymap.set("n", "<leader>cw", "<cmd>close<CR>", { desc = "[C]lose current [w]indow split" })
vim.keymap.set("n", "<leader>we", "<C-w>=", { desc = "Make split [w]indows [e]qual width & height" })
