return {
    -- Nahtlose Navigation zwischen Nvim-Splits und Tmux-Panes
    {
        "christoomey/vim-tmux-navigator",
        lazy = false,
    },

    -- Pi: AI-Coding-Agent
    {
        "pablopunk/pi.nvim",
        config = function()
            require("pi").setup({})
        end,
    },
}
