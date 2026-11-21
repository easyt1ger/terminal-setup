-- Keymaps zusätzlich zu LazyVim-Defaults
--
-- LazyVim hat bereits:
--   <C-h/j/k/l>   Fenster-Navigation
--   <leader>ff/sg/fb/sh  Snacks-Picker (Dateien, Grep, Buffer, Hilfe)
--   <leader>e      Snacks-Explorer
--   <leader>gg     Lazygit -- hier via toggleterm (plugins/ui.lua)
--   ]d/[d          Diagnostics
--   <S-h>/<S-l>    Buffer prev/next

-- Speichern/Beenden: LazyVim-Defaults nutzen (<C-s> speichern, <leader>qq beenden,
-- <leader>bd Buffer schließen). <leader>w/<leader>q sind dort Gruppen-Präfixe.
vim.keymap.set("n", "<leader>Q", "<cmd>quit!<cr>", { desc = "Force Quit" })

-- Alternativer Explorer-Shortcut (gewohntes <C-n>), entspricht <leader>e
vim.keymap.set("n", "<C-n>", function() Snacks.explorer() end, { desc = "Toggle Explorer" })

-- Terminal-Mode: Fenster-Navigation ohne normalen Modus
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { noremap = true })
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", { noremap = true })
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", { noremap = true })
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", { noremap = true })

-- Pi-Agent
vim.keymap.set({ "n", "v" }, "<leader>ai", function() require("pi").ask() end, { desc = "Pi: Ask" })
