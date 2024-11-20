return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        on_attach = function(bufnr)
            local git_signs = package.loaded.gitsigns

            local function map(mode, l, r, desc)
                vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
            end

            -- Navigation
            map("n", "]h", git_signs.next_hunk, "Next Hunk")
            map("n", "[h", git_signs.prev_hunk, "Prev Hunk")

            -- Actions
            map("n", "<leader>hs", git_signs.stage_hunk, "Stage hunk")
            map("n", "<leader>hr", git_signs.reset_hunk, "Reset hunk")
            map("v", "<leader>hs", function()
                git_signs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, "Stage hunk")
            map("v", "<leader>hr", function()
                git_signs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, "Reset hunk")

            map("n", "<leader>hS", git_signs.stage_buffer, "Stage buffer")
            map("n", "<leader>hR", git_signs.reset_buffer, "Reset buffer")

            map("n", "<leader>hu", git_signs.undo_stage_hunk, "Undo stage hunk")

            map("n", "<leader>hp", git_signs.preview_hunk, "Preview hunk")

            map("n", "<leader>hb", function()
                git_signs.blame_line({ full = true })
            end, "Blame line")
            map("n", "<leader>hB", git_signs.toggle_current_line_blame, "Toggle line blame")

            map("n", "<leader>hd", git_signs.diffthis, "Diff this")
            map("n", "<leader>hD", function()
                git_signs.diffthis("~")
            end, "Diff this ~")

            -- Text object
            map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Gitsigns select hunk")
        end,
    },
}
