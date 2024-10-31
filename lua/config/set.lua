-- File Tree style.
vim.g.netrw_liststyle = 3 -- Shows '|' in tree style.

-- Make line numbers default.
vim.opt.nu = true
-- Add relative line numbers, to help with jumping.
vim.opt.relativenumber = true

-- Configure Tabs
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.wrap = false

-- vim.opt.swapfile = false
-- vim.opt.backup = false
-- vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
-- vim.opt.undofile = true

-- Search Settings
vim.opt.ignorecase = true -- Ignore case when searching.
vim.opt.smartcase = true  -- If you include mixed case in your search it becomes case sensitive.
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- Decrease update time
vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

-- Spellcheck
vim.opt.spelllang = "en_us"
vim.opt.spell = true

-- Split windows
vim.opt.splitright = true -- split vertical window to the right
vim.opt.splitbelow = true -- split horizontal window to the bottom

-- Clipboard
vim.opt.clipboard:append("unnamedplus") -- use system clipboard as default register
