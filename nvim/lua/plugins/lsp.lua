return {
    -- Mason: Stylua zusätzlich zu den Sprach-Extras installieren
    {
        "mason-org/mason.nvim",
        opts = {
            ensure_installed = { "stylua" },
        },
    },

    -- lua_ls: Workspace-Einstellungen für Neovim-Konfigurationen
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            workspace = { checkThirdParty = false },
                        },
                    },
                },
            },
        },
    },

    -- Conform: Lua-Formatter (Python/TS/etc. kommen aus den Sprach-Extras)
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
            },
        },
    },
}
