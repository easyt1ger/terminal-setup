return {
    -- LazyVim auf Kanagawa umstellen
    {
        "LazyVim/LazyVim",
        opts = { colorscheme = "kanagawa" },
    },

    -- Kanagawa Theme
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            theme = "dragon",
            background = { dark = "dragon", light = "lotus" },
        },
    },
}
