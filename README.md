# Nvim + Terminal Workflow Guide

Vollständige Konfiguration für **Neovim + Fish + Starship + Ghostty** auf macOS und Linux.

## 📋 Inhaltsverzeichnis

1. [Schnellstart](#-schnellstart)
2. [Installation](#-installation)
3. [Keybindings](#-keybindings)
4. [Plugins Übersicht](#-plugins-übersicht)
5. [Workflow Tipps](#-workflow-tipps)
6. [Troubleshooting](#-troubleshooting)

---

## 🚀 Schnellstart

```bash
# 1. Script ausführbar machen
chmod +x setup.sh

# 2. Setup ausführen
./setup.sh

# 3. Terminal neustarten
# Dann: nvim
```

Das war's! Lazy.nvim lädt alle Plugins automatisch beim ersten Start.

---

## 📦 Installation

### Option 1: Automatisch (Empfohlen)
```bash
./setup.sh
```

Dies installiert:
- ✅ Neovim, Ghostty, Fish, Starship
- ✅ Alle Dependencies (fzf, ripgrep, git, etc.)
- ✅ LSP Server, Formatters
- ✅ Kopiert alle Configs

### Option 2: Manuell

#### macOS
```bash
brew install neovim ghostty starship fish fzf ripgrep exa tmux lazygit

# Configs kopieren
mkdir -p ~/.config/{nvim,fish,ghostty}
cp init.lua ~/.config/nvim/
cp config.fish ~/.config/fish/
cp starship.toml ~/.config/
cp ghostty-config ~/.config/ghostty/config

# Als Standard-Shell setzen
chsh -s /opt/homebrew/bin/fish
```

#### Linux (Arch Linux)
```bash
# Core packages
sudo pacman -S neovim fish git fzf ripgrep exa tmux lazygit

# Starship (über AUR)
paru -S starship
# oder yay -S starship
# oder direkt: curl -sS https://starship.rs/install.sh | sh -s -- --bin-dir ~/.local/bin

# Ghostty (über AUR)
paru -S ghostty
# oder yay -S ghostty

# Configs
mkdir -p ~/.config/{nvim,fish,ghostty}
cp init.lua ~/.config/nvim/
cp config.fish ~/.config/fish/
cp starship.toml ~/.config/
cp ghostty-config ~/.config/ghostty/config

chsh -s /usr/bin/fish
```

#### Linux (Debian/Ubuntu)
```bash
sudo apt install neovim fish git fzf ripgrep tmux

# Starship
curl -sS https://starship.rs/install.sh | sh

# Configs
mkdir -p ~/.config/{nvim,fish,ghostty}
cp init.lua ~/.config/nvim/
cp config.fish ~/.config/fish/
cp starship.toml ~/.config/
cp ghostty-config ~/.config/ghostty/config

chsh -s /usr/bin/fish
```

### LSP Server installieren

Nach dem Setup, zum optionalen Installieren von LSP Servern:

```bash
# macOS
brew install lua-language-server pyright typescript-language-server rust-analyzer

# Arch Linux
sudo pacman -S lua-language-server rust-analyzer yaml-language-server
npm install -g pyright typescript-language-server

# Debian/Ubuntu
npm install -g pyright typescript-language-server yaml-language-server
```

#### AUR Helper für Arch (optional)

Wenn du noch keinen AUR Helper hast:

```bash
# paru (recommended)
sudo pacman -S base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si

# oder yay
sudo pacman -S base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

---

## ⌨️ Keybindings

### Grundlagen

| Key | Action |
|-----|--------|
| `<Space>` | Leader Key |
| `<C-h/j/k/l>` | Window Navigation |
| `<Esc>` | Clear Search |

### Navigation

| Keybinding | Action |
|-----------|--------|
| `<leader>ff` | Find Files (Telescope) |
| `<leader>fg` | Live Grep |
| `<leader>fb` | Open Buffers |
| `<leader>fh` | Help Tags |
| `<leader>gs` | Git Status |
| `<leader>gc` | Git Commits |

### Editor

| Keybinding | Action |
|-----------|--------|
| `<leader>w` | Save |
| `<leader>q` | Quit |
| `<leader>Q` | Force Quit |
| `<leader>x` | Close Buffer |
| `<leader>bn` | Next Buffer |
| `<leader>bp` | Prev Buffer |
| `<leader>bd` | Delete Buffer |

### Terminal

| Keybinding | Action |
|-----------|--------|
| `<C-\>` | Toggle Terminal |
| `<C-h/j/k/l>` | Navigate (aus Terminal) |
| `<Esc>` | Exit Terminal Mode |

### LSP / Code

| Keybinding | Action |
|-----------|--------|
| `gd` | Go to Definition |
| `gD` | Go to Declaration |
| `gi` | Go to Implementation |
| `go` | Go to Type Definition |
| `gr` | References |
| `K` | Hover |
| `<leader>rn` | Rename |
| `<leader>ca` | Code Action |
| `<leader>dl` | Diagnostics |

### Git Integration

| Keybinding | Action |
|-----------|--------|
| `]c` | Next Hunk |
| `[c` | Prev Hunk |
| `<leader>hs` | Stage Hunk |
| `<leader>hr` | Reset Hunk |
| `<leader>hp` | Preview Hunk |
| `<leader>hb` | Blame Line |
| `<leader>tb` | Toggle Blame |
| `<leader>hd` | Diff This |
| `<leader>gg` | Lazygit |

### Formatieren

| Keybinding | Action |
|-----------|--------|
| `<leader>mp` | Format Document |

### Markdown Preview
| Keybinding | Action |
|-----------|--------|
| `<leader>md` | Markdown Preview Toggle |

### Pi Agentic Coding
| Keybinding | Action |
|-----------|--------|
| `<leader>ai` | Ask Pi (current buffer/selection as context) |

---

## 🔌 Plugins Übersicht

### UI & Navigation
- **lualine** - Status Bar
- **nvim-tree** - File Explorer
- **telescope** - Fuzzy Finder
- **dashboard** - Start Screen
- **kanagawa** - Farben Theme (Dragon Variant)

### Editor Features
- **nvim-surround** - Umgeben/Ändern (z.B., `cs"'`)
- **nvim-autopairs** - Auto Klammern
- **Comment.nvim** - Comment Toggle
- **indent-blankline** - Indent Guides
- **nvim-treesitter** - Syntax Highlighting

### Code & LSP
- **lsp-zero** - LSP Setup
- **nvim-lspconfig** - LSP Konfiguration
- **nvim-cmp** - Autocomplete
- **LuaSnip** - Snippets
- **conform** - Formatierung
- **nvim-lint** - Linting

### Git Integration
- **gitsigns** - Git Signs (Changed Lines)
- **telescope** - Git Integration

### Terminal & Tmux
- **toggleterm** - Terminal Inside Nvim
- **vim-tmux-navigator** - Tmux Navigation

### Produktivität
- **markdown-preview** - Markdown Preview
- **pi.nvim** - Agentic Coding (Pi Agent Integration)
- **vim-tmux-navigator** - Nahtlose Navigation

---

## 💡 Workflow Tipps

### 1. Terminal im Nvim öffnen

```
<C-\>  # Toggle Terminal
```

Häufig genutzt für:
- `git status`, `git diff`
- `npm run dev`, `python script.py`
- `cargo run`, `go run`
- `npm test`

### 2. Projekt schnell öffnen (Fish)

```bash
p  # Project picker mit fzf
```

Dies öffnet dein Projekt und startet nvim.

### 3. Git Workflow

```bash
<leader>gs     # Git Status
<leader>gg     # Lazygit (Full UI)
<leader>gc     # Git Commits (Telescope)
```

### 4. Schnelle Navigation

```bash
<leader>ff     # Datei suchen
<leader>fg     # Text überall suchen
```

### 5. Split Fenster Workflow

```bash
<C-h/j/k/l>   # Zwischen Fenstern navigieren
:split         # Horizontal split
:vsplit        # Vertikal split
```

### 6. Formatierung & Linting

```
<leader>mp    # Format
```

Auto-Format on Save ist eingebaut! Linting läuft automatisch.

### 7. LSP Features

```
gd     # Zur Definition springen
K      # Dokumentation anschauen
<leader>rn   # Variable umbenennen
```

### 8. Schnelle Notizen

```bash
note           # Neue Notiz
note "feature" # Notiz mit Namen
```

### 9. Fish Aliase

```bash
v file.py      # nvim öffnen
gs             # git status
gl             # git log
gco branch     # git checkout
```

### 10. Pi Agentic Coding (in Nvim)

**Pi** ist ein minimales, erweiterbares agentic coding agent. Du kannst es direkt aus Nvim nutzen:

```vim
<leader>ai     # Prompt öffnen, Pi nutzt aktuellen Buffer als Context
```

**Beispiele:**

```
Prompt: "Write a function that..."
Result: Pi schreibt Code, integriert Changes automatisch

Visual Selection + <leader>ai:
Result: Pi arbeitet nur auf selected Code
```

**Oder im Terminal:**

```bash
pi             # Starte Pi Agent
pi "Your prompt here"  # Schnell-Mode
```

**Features:**
- 📝 Context-aware (nutzt aktuellen Buffer/Selection)
- 🔧 Multi-Provider (Claude, GPT, Gemini, etc.)
- 🎯 Minimal & schnell
- 📦 Erweiterbar via Extensions

---

## 📊 Empfohlene LSP Server

### Python
```bash
pip install pyright
```

### JavaScript/TypeScript
```bash
npm install -g typescript-language-server
```

### Rust
```bash
rustup component add rust-analyzer
```

### Go
```bash
go install github.com/golang/tools/gopls@latest
```

### YAML
```bash
npm install -g yaml-language-server
```

---

## 🐛 Troubleshooting

### Problem: Plugins laden nicht

**Lösung:**
```vim
:Lazy
# Press 's' to sync
```

### Problem: LSP funktioniert nicht

**Check:**
```vim
:LspInfo
```

**Wenn Server nicht connected:**
```bash
# Stelle sicher, dass LSP installiert ist:
which pyright
npm list -g typescript-language-server
```

### Problem: Fish als Default Shell funktioniert nicht

```bash
# macOS
chsh -s /opt/homebrew/bin/fish

# Linux
chsh -s /usr/bin/fish
```

### Problem: Ghostty öffnet nicht

```bash
# macOS mit Homebrew
brew install ghostty

# Linux: Von GitHub bauen oder Distro-Package nutzen
```

### Problem: Starship Prompt wird nicht angezeigt

```bash
# In Fish config überprüfen:
cat ~/.config/fish/config.fish | grep starship

# Oder manuell initialisieren:
starship init fish | source
```

### Problem: Colors sehen komisch aus

**Terminal Settings überprüfen:**
```bash
# Ghostty config
~/.config/ghostty/config

# Echo um zu testen
echo "🌈 Colors: $(tput colors) colors"
```

### Terminal Flackern oder Lag

**In Ghostty config:**
```ini
graphics-protocol = kitty
# oder
graphics-protocol = sixel
```

### Fzf funktioniert nicht

```bash
# Überprüfen ob installiert:
which fzf

# Wenn nicht:
brew install fzf

# Dann in Fish config:
fzf --fish | source
```

---

## 🎨 Themes anpassen

### Nvim Colorscheme (Kanagawa)

Das Setup verwendet **Kanagawa Dragon** - ein wunderschönes modernes Theme.

**Varianten wechseln** in `~/.config/nvim/init.lua`:

```lua
require("kanagawa").setup({
    theme = "dragon",    -- Aktuelle: dunkel, warm
    -- "wave"            -- Alternative: dunkel, kühl
    -- "lotus"           -- Alternative: hell, minimalistisch
})
vim.cmd.colorscheme("kanagawa")
```

**Zu anderem Theme wechseln:**

```lua
-- Im init.lua Color Scheme section:
-- "tokyonight"
-- "nord"
-- "gruvbox"
-- "dracula"

vim.cmd.colorscheme("kanagawa")
```

### Starship Prompt anpassen

Edit `~/.config/starship.toml`:

```toml
[character]
success_symbol = "[➜](#76946a)"
error_symbol = "[➜](#c34043)"
```

### Fish Farben (Kanagawa Dragon)

`~/.config/fish/config.fish`:

```fish
# Kanagawa Dragon colors
set fish_color_command 7e9cd8          # Blau
set fish_color_error c34043            # Rot
set fish_color_comment 595959          # Grau
set fish_color_param 7e9cd8            # Blau
set fish_color_quote c8c093            # Gelb
# ... weitere Colors
```

### Pi Agent konfigurieren

Pi liest Umgebungsvariablen für Provider:

```bash
# Anthropic (Claude)
export ANTHROPIC_API_KEY="sk-ant-..."

# OpenAI (GPT)
export OPENAI_API_KEY="sk-..."

# Google Gemini
export GEMINI_API_KEY="..."

# Oder: pi /login (für Claude Pro/ChatGPT Plus)
```

**Pi Provider ändern in Nvim:**

```lua
-- In ~/.config/nvim/init.lua:
require("pi").setup({
    provider = "anthropic",  -- oder "openai", "gemini"
    model = "claude-opus",   -- oder "gpt-4", etc.
})
```

**Fish Shortcut für Pi:**

```fish
alias pi-ask "pi --prompt"
alias pi-edit "pi --edit"
```

---

## 📚 Zusätzliche Resources

- Nvim Docs: `:help nvim`
- Treesitter: https://github.com/nvim-treesitter
- Telescope: https://github.com/nvim-telescope/telescope.nvim
- Fish Shell: https://fishshell.com
- Starship: https://starship.rs
- Ghostty: https://ghostty.org
- **Pi Agent:** https://pi.dev (Agentic Coding)
- **pi.nvim:** https://github.com/pablopunk/pi.nvim (Nvim Integration)

---

## 🔥 Pro-Tipps

1. **Makros aufnehmen:** `q` + Buchstabe zum Starten/Beenden
2. **Text ObjectLike:** `di"` = Delete inside quotes
3. **Dot Repeat:** `.` wiederholt letzte Aktion
4. **Jump List:** `Ctrl-o`/`Ctrl-i` zum Navigieren
5. **Marks:** `m` + Buchstabe zum setzen, `'` + Buchstabe zum jumpen

---

## 💬 Support

Falls Probleme auftreten:

1. Check `:LspInfo` und `:Lazy` in nvim
2. Logs anschauen: `~/.config/nvim/logs/`
3. Configs checken: `~/.config/{nvim,fish,ghostty}`
4. Neovim + Plugin Repos auf GitHub durchsuchen

---

**Viel Spaß mit deinem produktiven Terminal Setup! 🚀**
