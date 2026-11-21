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
- ✅ Formatter (LSP-Server installiert später Mason automatisch)
- ✅ Kopiert alle Configs (`nvim/`, `config.fish`, `starship.toml`, `ghostty-config`)

### Option 2: Manuell

#### macOS
```bash
brew install neovim ghostty starship fish fzf ripgrep eza tmux lazygit

# Configs kopieren
mkdir -p ~/.config/{nvim,fish,ghostty}
cp -r nvim/. ~/.config/nvim/
cp config.fish ~/.config/fish/
cp starship.toml ~/.config/
cp ghostty-config ~/.config/ghostty/config

# Als Standard-Shell setzen
chsh -s /opt/homebrew/bin/fish
```

#### Linux (Arch Linux)
```bash
# Core packages
sudo pacman -S neovim fish git fzf ripgrep eza tmux lazygit

# Starship (über AUR)
paru -S starship
# oder yay -S starship
# oder direkt: curl -sS https://starship.rs/install.sh | sh -s -- --bin-dir ~/.local/bin

# Ghostty (über AUR)
paru -S ghostty
# oder yay -S ghostty

# Configs
mkdir -p ~/.config/{nvim,fish,ghostty}
cp -r nvim/. ~/.config/nvim/
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
cp -r nvim/. ~/.config/nvim/
cp config.fish ~/.config/fish/
cp starship.toml ~/.config/
cp ghostty-config ~/.config/ghostty/config

chsh -s /usr/bin/fish
```

### LSP Server & Formatter

Nichts manuell nötig: Beim ersten Start von `nvim` installiert **Mason** die
Server und Formatter der aktivierten LazyVim-Sprach-Extras
(Python, TypeScript, Rust, JSON, YAML) plus `stylua`.

```vim
:Mason        " Status ansehen / weitere Tools installieren
```

Voraussetzungen: `node`/`npm` und `python` sollten installiert sein.

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

> 📄 Vollständige Liste: **[KEYBINDINGS.md](KEYBINDINGS.md)**

`<leader>` = **Leertaste**. Die Ebenen sind getrennt:

| Ebene | Modifier | Wofür |
|-------|----------|-------|
| Ghostty | `Alt+Shift` / `Ctrl+Alt` | Tabs & Splits des Terminals |
| Neovim | `Ctrl` / `<leader>` | Fenster, Editor-Aktionen |
| Fish | `Ctrl` (+ fzf) | Shell-Suche, History |

### Ghostty

| Keybinding | Action |
|-----------|--------|
| `Ctrl+Alt+h/j/k/l` | Split-Fokus links / unten / oben / rechts |
| `Alt+Shift+h` / `Alt+Shift+l` | Vorheriger / nächster Tab |
| `Alt+Shift+t` | Neuer Tab |
| `Alt+Shift+v` | Neuer Split rechts |
| `Alt+Shift+s` | Neuer Split unten |
| `Ctrl+Shift+c` / `Ctrl+Shift+v` | Kopieren / Einfügen |
| `Ctrl+Shift+,` | Config neu laden |

### Fish

| Keybinding | Action |
|-----------|--------|
| `Ctrl+r` | History durchsuchen (fzf) |
| `Ctrl+t` | Datei suchen & einfügen (fzf) |
| `Alt+c` | Verzeichnis wechseln (fzf) |
| `→` / `Ctrl+f` | Autosuggestion übernehmen |
| `Alt+s` | `sudo` voranstellen |

### Neovim: Grundlagen

| Keybinding | Action |
|-----------|--------|
| `<C-h/j/k/l>` | Fenster-Navigation (auch aus dem Terminal) |
| `<C-s>` | Speichern |
| `<leader>qq` | Alles beenden |
| `<leader>Q` | Schließen ohne Speichern |
| `<leader>` (warten) | which-key zeigt alle Optionen |

### Neovim: Dateien & Suche

| Keybinding | Action |
|-----------|--------|
| `<leader><leader>` / `<leader>ff` | Dateien finden |
| `<leader>/` / `<leader>sg` | Grep im Projekt |
| `<leader>,` / `<leader>fb` | Buffer wählen |
| `<leader>fr` | Zuletzt geöffnet |
| `<leader>e` / `<C-n>` | Datei-Explorer |
| `<leader>sr` | Suchen & Ersetzen |
| `<leader>sk` | Keymaps durchsuchen |

### Neovim: Buffer & Fenster

| Keybinding | Action |
|-----------|--------|
| `<S-h>` / `<S-l>` | Vorheriger / nächster Buffer |
| `<leader>bb` | Zum letzten Buffer |
| `<leader>bd` | Buffer schließen |
| `<leader>-` / `<leader>\|` | Split unten / rechts |
| `<A-j>` / `<A-k>` | Zeile verschieben |

### Neovim: Terminal

| Keybinding | Action |
|-----------|--------|
| `<C-\>` | Floating Terminal ein/aus |
| `<C-h/j/k/l>` | Aus dem Terminal in andere Fenster |

### Neovim: LSP / Code

| Keybinding | Action |
|-----------|--------|
| `gd` | Go to Definition |
| `gD` | Go to Declaration |
| `gI` | Go to Implementation |
| `gy` | Go to Type Definition |
| `gr` | References |
| `K` | Hover |
| `<leader>cr` | Rename |
| `<leader>ca` | Code Action |
| `<leader>cf` | Format |
| `<leader>cd` | Line Diagnostics |
| `<leader>xx` | Diagnostics-Liste (Trouble) |
| `]d` / `[d` | Nächste / vorherige Diagnose |

### Neovim: Git

| Keybinding | Action |
|-----------|--------|
| `<leader>gg` | Lazygit |
| `<leader>gs` | Git Status |
| `<leader>gl` | Git Log |
| `]h` / `[h` | Nächster / vorheriger Hunk |
| `<leader>ghs` | Stage Hunk |
| `<leader>ghr` | Reset Hunk |
| `<leader>ghp` | Preview Hunk |
| `<leader>ghb` | Blame Line |
| `<leader>ghd` | Diff This |

### Neovim: Pi Agentic Coding

| Keybinding | Action |
|-----------|--------|
| `<leader>ai` | Ask Pi (aktueller Buffer/Auswahl als Kontext) |

---

## 🔌 Plugins Übersicht

Basis ist **[LazyVim](https://www.lazyvim.org)**, verwaltet über `lazy.nvim`.

### Config-Struktur

```
nvim/
├── init.lua                  # lädt config.lazy
└── lua/
    ├── config/
    │   ├── lazy.lua          # lazy.nvim + LazyVim + Sprach-Extras
    │   ├── options.lua       # eigene Optionen (4 Spaces, Diagnose-Float …)
    │   └── keymaps.lua       # eigene Keymaps
    └── plugins/
        ├── colorscheme.lua   # Kanagawa Dragon
        ├── lsp.lua           # lua_ls, stylua, conform
        ├── tools.lua         # vim-tmux-navigator, pi.nvim
        └── ui.lua            # lualine, toggleterm, snacks-Overrides
```

### UI & Navigation
- **snacks.nvim** – Picker (Dateien, Grep, Buffer), Explorer, Dashboard, Notifications
- **lualine** – Statusleiste (Kanagawa-Theme, global)
- **bufferline** – Buffer-Tabs
- **which-key** – Zeigt verfügbare Tastenkombinationen
- **noice** – Moderne Cmdline & Messages
- **kanagawa** – Farbschema (Dragon)

### Editor
- **flash.nvim** – Schnell springen (`s`)
- **mini.pairs** – Auto-Klammern
- **mini.ai** – Erweiterte Textobjekte
- **ts-comments** – Kommentieren (`gcc`)
- **nvim-treesitter** – Syntax Highlighting
- **grug-far** – Suchen & Ersetzen im Projekt
- **todo-comments** – TODO/FIXME hervorheben
- **persistence** – Sessions

### Code & LSP
- **nvim-lspconfig** + **mason** – LSP-Server
- **blink.cmp** – Autocomplete
- **friendly-snippets** – Snippets
- **conform** – Formatierung (Format on Save)
- **nvim-lint** – Linting
- **trouble** – Diagnose-Liste
- **Sprach-Extras:** Python (venv-selector), TypeScript, Rust (rustaceanvim, crates), JSON/YAML (SchemaStore)

### Git
- **gitsigns** – Änderungen in der Sign-Column, Hunk-Aktionen
- **lazygit** – über toggleterm (`<leader>gg`)

### Terminal & Tools
- **toggleterm** – Floating Terminal (`<C-\>`) und Lazygit
- **vim-tmux-navigator** – Nahtlose Navigation Nvim ↔ tmux
- **pi.nvim** – Agentic Coding (Pi Agent Integration)

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
<leader>gl     # Git Log
```

### 4. Schnelle Navigation

```bash
<leader>ff     # Datei suchen
<leader>/      # Text überall suchen
```

### 5. Split Fenster Workflow

```bash
<C-h/j/k/l>        # Zwischen Nvim-Fenstern navigieren
<leader>-          # Split unten
<leader>|          # Split rechts
Ctrl+Alt+h/j/k/l   # Zwischen Ghostty-Splits navigieren
```

### 6. Formatierung & Linting

```
<leader>cf    # Format
```

Auto-Format on Save ist eingebaut! Linting läuft automatisch.

### 7. LSP Features

```
gd     # Zur Definition springen
K      # Dokumentation anschauen
<leader>cr   # Variable umbenennen
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

## 📊 Weitere Sprachen hinzufügen

Weitere Sprachen über LazyVim-Extras in `nvim/lua/config/lazy.lua` aktivieren,
z. B. Go:

```lua
{ import = "lazyvim.plugins.extras.lang.go" },
```

Oder interaktiv: `:LazyExtras` in nvim. Mason installiert die nötigen Tools dann automatisch.

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
```vim
:Mason          " Ist der Server installiert?
:checkhealth    " Allgemeine Diagnose
```

### Problem: Fish als Default Shell funktioniert nicht

```bash
# macOS
chsh -s /opt/homebrew/bin/fish

# Linux
chsh -s /usr/bin/fish
```

### Problem: Ghostty öffnet nicht / Config-Fehler

```bash
# macOS mit Homebrew
brew install ghostty

# Arch (AUR)
paru -S ghostty

# Config prüfen
ghostty +validate-config
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

### Fzf funktioniert nicht

```bash
# Überprüfen ob installiert:
which fzf

# Wenn nicht:
brew install fzf        # macOS
sudo pacman -S fzf      # Arch

# Dann in Fish config:
fzf --fish | source
```

---

## 🎨 Themes anpassen

### Nvim Colorscheme (Kanagawa)

Das Setup verwendet **Kanagawa Dragon** - ein wunderschönes modernes Theme.

**Varianten wechseln** in `nvim/lua/plugins/colorscheme.lua`:

```lua
{
    "rebelot/kanagawa.nvim",
    opts = {
        theme = "dragon",    -- Aktuell: dunkel, warm
        -- "wave"            -- Alternative: dunkel, kühl
        -- "lotus"           -- Alternative: hell
    },
},
```

**Zu anderem Theme wechseln** (gleiche Datei):

```lua
{ "LazyVim/LazyVim", opts = { colorscheme = "tokyonight" } },
```

Mitgeliefert sind `kanagawa`, `tokyonight` und `catppuccin`; andere Themes als Plugin ergänzen.

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

**pi.nvim konfigurieren** in `nvim/lua/plugins/tools.lua`
(Optionen siehe [pi.nvim README](https://github.com/pablopunk/pi.nvim)):

```lua
{
    "pablopunk/pi.nvim",
    config = function()
        require("pi").setup({})
    end,
},
```

**Fish-Funktionen für Pi** (in `config.fish` enthalten):

```fish
pi-ask "Erkläre mir diesen Fehler"
pi-file main.py "Refactor diese Datei"
```

---

## 📚 Zusätzliche Resources

- Nvim Docs: `:help nvim`
- Treesitter: https://github.com/nvim-treesitter
- LazyVim Keymaps: https://www.lazyvim.org/keymaps
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
2. Diagnose: `:checkhealth`, Logs unter `~/.local/state/nvim/`
3. Configs checken: `~/.config/{nvim,fish,ghostty}`
4. Neovim + Plugin Repos auf GitHub durchsuchen

---

**Viel Spaß mit deinem produktiven Terminal Setup! 🚀**
