-- Keymaps zusätzlich zu LazyVim-Defaults
--
-- LazyVim hat bereits:
--   <C-h/j/k/l>   Fenster-Navigation
--   <leader>ff/fg/fb/fh  Telescope
--   <leader>e      Neo-tree toggle
--   <leader>gg     Lazygit (snacks) -- wird durch toggleterm überschrieben
--   ]d/[d          Diagnostics
--   <S-h>/<S-l>    Buffer prev/next

-- Schnellspeichern / Beenden
vim.keymap.set("n", "<leader>w", "<cmd>write<cr>", { desc = "Save" })
vim.keymap.set("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit" })
vim.keymap.set("n", "<leader>Q", "<cmd>quit!<cr>", { desc = "Force Quit" })

-- Alternativer Neo-tree Shortcut (gewohntes <C-n>)
vim.keymap.set("n", "<C-n>", "<cmd>Neotree toggle<cr>", { desc = "Toggle Neo-tree" })

-- Terminal-Mode: Fenster-Navigation ohne normalen Modus
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { noremap = true })
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", { noremap = true })
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", { noremap = true })
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", { noremap = true })

-- Pi-Agent
vim.keymap.set({ "n", "v" }, "<leader>ai", function() require("pi").ask() end, { desc = "Pi: Ask" })
