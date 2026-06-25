return {
    -- Lualine mit Kanagawa-Theme
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = {
                theme = "kanagawa",
                globalstatus = true,
            },
        },
    },

    -- Floating Terminal mit <C-\> + Lazygit via toggleterm
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        keys = {
            { [[<C-\>]], desc = "Toggle terminal" },
            { "<leader>gg", desc = "Lazygit" },
        },
        opts = {
            open_mapping = [[<C-\>]],
            direction = "float",
            float_opts = {
                border = "curved",
                height = 0.8,
                width = 0.9,
            },
            shell = vim.o.shell,
        },
        config = function(_, opts)
            require("toggleterm").setup(opts)
            local Terminal = require("toggleterm.terminal").Terminal
            local lazygit = Terminal:new({ cmd = "lazygit", direction = "float", hidden = true })
            vim.keymap.set("n", "<leader>gg", function() lazygit:toggle() end, { desc = "Lazygit" })
        end,
    },

    -- Snacks: Terminal und Lazygit deaktiviert (toggleterm übernimmt)
    {
        "folke/snacks.nvim",
        opts = {
            terminal = { enabled = false },
            lazygit = { enabled = false },
        },
    },
}
