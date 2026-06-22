require("nvim-tree").setup({
    view = {
        width = 35,
    },
    renderer = {
        group_empty = false,
        icons = {
            web_devicons = {
                file = { enable = true, color = true },
                folder = { enable = false },
            },
            git_placement = "before",
        },
    },
    filters = {
        dotfiles = false,
    },
    git = {
        enable = true,
        ignore = false,
    },
    filesystem_watchers = {
        enable = false,
    },
    actions = {
        open_file = {
            quit_on_open = false,
        },
    },
})
