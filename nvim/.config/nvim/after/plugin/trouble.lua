require("trouble").setup()

-- trouble.nvim v3 command syntax: `:Trouble <mode> <action>`
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",
    { silent = true, noremap = true, desc = "Diagnostics (Trouble)" }
)
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>",
    { silent = true, noremap = true, desc = "Quickfix (Trouble)" }
)
