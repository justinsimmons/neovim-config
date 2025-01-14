vim.keymap.set("n", "<leader>pv", vim.cmd.Ex,
    { desc = "Go to the [P]evious [v]iew" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Override page up and down keymaps to align in the middle of the page.
vim.keymap.set("n", "<C-d>", "<C-d>zz",
    { desc = "Jump down half a page" })
vim.keymap.set("n", "<C-u>", "<C-u>zz",
    { desc = "Jump up half a page" })

-- Paste without deleting whats in buffer.
vim.keymap.set("x", "<leader>p", [["_dP]],
    { desc = "[P]aste without deleting buffer contents" })

-- Copy to system clipboard.
-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Window Management
vim.keymap.set("n", "<leader>cw", "<cmd>close<CR>",
    { desc = "[C]lose current [w]indow split" })
vim.keymap.set("n", "<leader>we", "<C-w>=",
    { desc = "Make split [w]indows [e]qual width & height" })

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup(
        'kickstart-highlight-yank',
        { clear = true }
    ),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
