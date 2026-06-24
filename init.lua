-- Neovim Configuration
-- Modern, productive setup für Mac + Linux mit Fish/Starship/Ghostty

-- Leader Key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic Options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes:2"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.clipboard = "unnamedplus"

-- Diagnostics
vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    underline = true,
    float = { border = "rounded" },
})

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({
    -- Color Scheme
    {
        "rebelot/kanagawa.nvim",
        priority = 1000,
        config = function()
            require("kanagawa").setup({
                compile = false,
                undercurl = true,
                colors = {
                    palette = {},
                    theme = {
                        all = {
                            ui = "bg",
                            float = "bg",
                        },
                    },
                },
                overrides = function()
                    return {}
                end,
                theme = "dragon",
                background = {
                    dark = "dragon",
                    light = "lotus",
                },
            })
            vim.cmd.colorscheme("kanagawa")
        end,
    },

    -- UI Improvements
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "kanagawa",
                    globalstatus = true,
                },
            })
        end,
    },

    -- File Explorer
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup({
                view = { width = 30 },
                git = { enable = true },
                filters = { dotfiles = false },
            })
            vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true })
            vim.keymap.set("n", "<leader>e", ":NvimTreeFocus<CR>", { noremap = true })
        end,
    },

    -- Fuzzy Finder
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "BurntSushi/ripgrep",
        },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")

            telescope.setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<Esc>"] = actions.close,
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                        },
                    },
                    layout_strategy = "horizontal",
                    layout_config = { height = 0.9 },
                },
            })

            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
            vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
            vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
            vim.keymap.set("n", "<leader>gs", builtin.git_status, {})
            vim.keymap.set("n", "<leader>gc", builtin.git_commits, {})
        end,
    },

    -- Git Integration
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    -- Navigation
                    map("n", "]c", function()
                        if vim.wo.diff then return "]c" end
                        vim.schedule(function() gs.next_hunk() end)
                        return "<Ignore>"
                    end, { expr = true })
                    map("n", "[c", function()
                        if vim.wo.diff then return "[c" end
                        vim.schedule(function() gs.prev_hunk() end)
                        return "<Ignore>"
                    end, { expr = true })

                    -- Actions
                    map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
                    map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
                    map("n", "<leader>hS", gs.stage_buffer)
                    map("n", "<leader>hu", gs.undo_stage_hunk)
                    map("n", "<leader>hR", gs.reset_buffer)
                    map("n", "<leader>hp", gs.preview_hunk)
                    map("n", "<leader>hb", function() gs.blame_line({ full = true }) end)
                    map("n", "<leader>tb", gs.toggle_current_line_blame)
                    map("n", "<leader>hd", gs.diffthis)
                    map("n", "<leader>hD", function() gs.diffthis("~") end)
                    map("n", "<leader>td", gs.toggle_deleted)

                    -- Text object
                    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
                end,
            })
        end,
    },

    -- Terminal Integration
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            require("toggleterm").setup({
                open_mapping = [[<C-\>]],
                direction = "float",
                float_opts = {
                    border = "curved",
                    height = 0.8,
                    width = 0.9,
                },
                shell = vim.o.shell,
            })

            local Terminal = require("toggleterm.terminal").Terminal
            local lazygit = Terminal:new({ cmd = "lazygit", direction = "float", hidden = true })

            function _lazygit_toggle()
                lazygit:toggle()
            end

            vim.keymap.set("n", "<leader>gg", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true })
        end,
    },

    -- Tmux Navigation
    {
        "christoomey/vim-tmux-navigator",
        lazy = false,
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "lua",
                    "python",
                    "javascript",
                    "typescript",
                    "rust",
                    "bash",
                    "vim",
                    "json",
                    "yaml",
                    "markdown",
                },
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },

    -- LSP Zero (LSP Setup)
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        dependencies = {
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/nvim-cmp",
            "L3MON4D3/LuaSnip",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            local lsp_zero = require("lsp-zero")
            lsp_zero.extend_lspconfig()

            lsp_zero.on_attach(function(client, bufnr)
                lsp_zero.default_keymaps({ buffer = bufnr })
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr })
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr })
                vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr })
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr })
                vim.keymap.set("n", "go", vim.lsp.buf.type_definition, { buffer = bufnr })
                vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr })
                vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float, { buffer = bufnr })
            end)

            -- Autocompletion
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }, {
                    { name = "buffer" },
                    { name = "path" },
                }),
            })

            require("lspconfig").lua_ls.setup(lsp_zero.nvim_lua_ls())

            -- Python
            require("lspconfig").pyright.setup({})

            -- JavaScript/TypeScript
            require("lspconfig").ts_ls.setup({})

            -- Rust
            require("lspconfig").rust_analyzer.setup({})

            -- JSON
            require("lspconfig").jsonls.setup({})

            -- YAML
            require("lspconfig").yamlls.setup({})
        end,
    },

    -- Formatting
    {
        "stevearc/conform.nvim",
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    lua = { "stylua" },
                    python = { "black", "isort" },
                    javascript = { "prettier" },
                    typescript = { "prettier" },
                    json = { "prettier" },
                    yaml = { "prettier" },
                    markdown = { "prettier" },
                },
                format_on_save = {
                    timeout_ms = 500,
                    lsp_fallback = true,
                },
            })
            vim.keymap.set("n", "<leader>mp", function()
                require("conform").format({ async = true, lsp_fallback = true })
            end)
        end,
    },

    -- Linting
    {
        "mfussenegger/nvim-lint",
        config = function()
            local lint = require("lint")

            lint.linters_by_ft = {
                python = { "pylint" },
                javascript = { "eslint" },
                typescript = { "eslint" },
            }

            vim.api.nvim_create_autocmd({ "BufWritePost" }, {
                callback = function()
                    lint.try_lint()
                end,
            })

            vim.keymap.set("n", "<leader>ml", function() lint.try_lint() end)
        end,
    },

    -- Comments
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    },

    -- Surround
    {
        "kylechui/nvim-surround",
        version = "*",
        config = function()
            require("nvim-surround").setup({})
        end,
    },

    -- Pairs
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({
                check_ts = true,
            })
        end,
    },

    -- Indent Guides
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("ibl").setup({
                indent = { char = "▏" },
                scope = { enabled = true },
            })
        end,
    },

    -- Agentic Coding
    {
        "pablopunk/pi.nvim",
        config = function()
            require("pi").setup({
                -- Pi wird automatisch erkannt (npm global installiert)
            })
            
            -- Keybindings für Pi
            vim.keymap.set("n", "<leader>ai", function()
                require("pi").ask()
            end, { noremap = true, desc = "Pi: Ask (current buffer as context)" })
            
            vim.keymap.set("v", "<leader>ai", function()
                require("pi").ask()
            end, { noremap = true, desc = "Pi: Ask (selection as context)" })
        end,
    },

    -- Dashboard
    {
        "nvimdev/dashboard-nvim",
        event = "VimEnter",
        config = function()
            require("dashboard").setup({
                theme = "doom",
                config = {
                    header = {
                        "",
                        "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
                        "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
                        "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
                        "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
                        "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
                        "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
                        "",
                    },
                    center = {
                        { icon = " ", desc = "New File", key = "n", action = "enew" },
                        { icon = " ", desc = "Find Files", key = "f", action = "Telescope find_files" },
                        { icon = " ", desc = "Recent Files", key = "r", action = "Telescope oldfiles" },
                        { icon = " ", desc = "Find Word", key = "w", action = "Telescope live_grep" },
                        { icon = " ", desc = "Settings", key = "s", action = "edit $MYVIMRC" },
                        { icon = " ", desc = "Quit", key = "q", action = "quit" },
                    },
                },
            })
        end,
    },
}, {
    ui = {
        icons = {
            cmd = "⌘",
            config = "🛠",
            event = "📅",
            ft = "📂",
            init = "⚙",
            keys = "🔑",
            plugin = "🔌",
            runtime = "💻",
            source = "📄",
            start = "🚀",
            task = "📋",
            lazy = "💤 ",
        },
    },
})

-- Key Mappings
-- Navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true })

-- Terminal Mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { noremap = true })
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", { noremap = true })
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", { noremap = true })
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", { noremap = true })

-- Buffer Navigation
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { noremap = true })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { noremap = true })
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { noremap = true })

-- Better indenting
vim.keymap.set("v", "<", "<gv", { noremap = true })
vim.keymap.set("v", ">", ">gv", { noremap = true })

-- Quick actions
vim.keymap.set("n", "<leader>w", ":write<CR>", { noremap = true })
vim.keymap.set("n", "<leader>q", ":quit<CR>", { noremap = true })
vim.keymap.set("n", "<leader>Q", ":quit!<CR>", { noremap = true })
vim.keymap.set("n", "<leader>x", ":bdelete<CR>", { noremap = true })

-- Clear search
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { noremap = true })

-- Diagnostics
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { noremap = true })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { noremap = true })

-- MarkdownPreview
vim.keymap.set("n", "<leader>mp", ":MarkdownPreviewToggle<CR>", { noremap = true })
