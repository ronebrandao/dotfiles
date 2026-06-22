local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- Theme
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

    -- File explorer
    {
        "nvim-tree/nvim-tree.lua",
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    -- Diagnostics panel
    { "folke/trouble.nvim", lazy = false },

    -- Syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = false,
    },

    -- Status bar
    { "nvim-lualine/lualine.nvim", lazy = false },

    -- Formatting
    { "stevearc/conform.nvim", lazy = false },

    -- Fuzzy finder
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
    },

    -- Quick file navigation
    { "theprimeagen/harpoon", lazy = false },

    -- Markdown rendering
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
        ft = { "markdown" },
    },

    -- LSP stack
    { "neovim/nvim-lspconfig", lazy = false },
    { "williamboman/mason.nvim", lazy = false },
    { "williamboman/mason-lspconfig.nvim", lazy = false },
    { "hrsh7th/nvim-cmp", lazy = false },
    { "hrsh7th/cmp-buffer", lazy = false },
    { "hrsh7th/cmp-path", lazy = false },
    { "saadparwaiz1/cmp_luasnip", lazy = false },
    { "hrsh7th/cmp-nvim-lsp", lazy = false },
    { "hrsh7th/cmp-nvim-lua", lazy = false },
    { "L3MON4D3/LuaSnip", lazy = false },
    { "rafamadriz/friendly-snippets", lazy = false },

    -- Java LSP (requires ftplugin/java.lua for attachment)
    { "mfussenegger/nvim-jdtls", lazy = false },

    -- Debugger
    { "mfussenegger/nvim-dap", lazy = false },
    {
        "rcarriga/nvim-dap-ui",
        lazy = false,
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    },
    { "mfussenegger/nvim-dap-python", lazy = false },
    { "jay-babu/mason-nvim-dap.nvim", lazy = false },
})
