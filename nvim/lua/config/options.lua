-- Overrides für LazyVim-Defaults
-- LazyVim nutzt 2 Spaces; wir bevorzugen 4
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Zwei Spalten für Zeichen (Sign + Diagnose nebeneinander)
vim.opt.signcolumn = "yes:2"

-- Persistentes Undo in eigenem Verzeichnis
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Diagnose-Anzeige: kein virtual_text, Float mit Border
vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    underline = true,
    float = { border = "rounded" },
})
