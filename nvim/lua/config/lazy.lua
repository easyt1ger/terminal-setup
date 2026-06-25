-- Leader muss vor lazy.setup gesetzt werden
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local out = vim.fn.system({
        "git", "clone", "--filter=blob:none", "--branch=stable",
        "https://github.com/folke/lazy.nvim.git", lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to continue..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        -- LazyVim core + alle default plugins
        { "LazyVim/LazyVim", import = "lazyvim.plugins" },
        -- Sprach-Extras (LSP, Formatter, Linter gebündelt)
        { import = "lazyvim.plugins.extras.lang.python" },
        { import = "lazyvim.plugins.extras.lang.typescript" },
        { import = "lazyvim.plugins.extras.lang.rust" },
        { import = "lazyvim.plugins.extras.lang.json" },
        { import = "lazyvim.plugins.extras.lang.yaml" },
        -- Eigene Plugins und Overrides
        { import = "plugins" },
    },
    defaults = { lazy = false, version = false },
    install = { colorscheme = { "kanagawa", "tokyonight", "habamax" } },
    checker = { enabled = true, notify = false },
    performance = {
        rtp = {
            disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
        },
    },
})
