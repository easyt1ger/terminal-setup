# Tastenkombinationen – Cheatsheet

Stand: Konfiguration in diesem Repo (Ghostty + Fish + Neovim/LazyVim).
`<leader>` = **Leertaste**. `C-` = Ctrl, `A-` = Alt, `S-` = Shift.

Faustregel für die Ebenen:

| Ebene | Modifier | Wofür |
|---|---|---|
| Ghostty | **Alt+Shift** / **Ctrl+Alt** | Tabs & Splits des Terminals |
| Neovim | **Ctrl** / **Leertaste** | Fenster, Editor-Aktionen |
| Fish | **Ctrl** (+ fzf) | Shell-Suche, History |

---

## 1. Ghostty (Terminal)

| Taste | Aktion |
|---|---|
| `Ctrl+Alt+h` / `j` / `k` / `l` | Fokus Split links / unten / oben / rechts |
| `Alt+Shift+h` | Vorheriger Tab |
| `Alt+Shift+l` | Nächster Tab |
| `Alt+Shift+t` | Neuer Tab |
| `Alt+Shift+v` | Neuer Split rechts (vertikal) |
| `Alt+Shift+s` | Neuer Split unten (horizontal) |
| Text markieren | Kopiert automatisch (`copy-on-select`) |

Ghostty-Defaults (nicht überschrieben, gelten weiterhin):

| Taste | Aktion |
|---|---|
| `Ctrl+Shift+c` / `Ctrl+Shift+v` | Kopieren / Einfügen |
| `Ctrl+Shift+w` | Split/Tab schließen |
| `Ctrl+=` / `Ctrl+-` / `Ctrl+0` | Schrift größer / kleiner / zurücksetzen |
| `Ctrl+Shift+,` | Config neu laden |

> `Alt+h/j/k/l` (ohne Ctrl) bleibt frei und kommt in Fish und Neovim an
> (z. B. LazyVims `Alt+j/k` = Zeile verschieben).

---

## 2. Fish Shell

### fzf-Integration (`fzf --fish`)

| Taste | Aktion |
|---|---|
| `Ctrl+r` | History durchsuchen |
| `Ctrl+t` | Datei suchen & Pfad einfügen |
| `Alt+c` | Verzeichnis suchen & hineinwechseln |

### Fish-Defaults

| Taste | Aktion |
|---|---|
| `→` / `Ctrl+f` | Autosuggestion übernehmen |
| `Alt+→` / `Alt+f` | Ein Wort der Suggestion übernehmen |
| `Tab` | Vervollständigen |
| `Alt+s` | `sudo` vor den Befehl setzen |
| `Alt+e` / `Alt+v` | Befehlszeile in `$EDITOR` (nvim) bearbeiten |
| `Ctrl+w` | Wort links löschen |
| `Ctrl+u` / `Ctrl+k` | Bis Zeilenanfang / -ende löschen |
| `Ctrl+l` | Bildschirm leeren |

### Aliases & Funktionen

| Befehl | Aktion |
|---|---|
| `v [datei]` | nvim; ohne Argument: Datei per fzf wählen |
| `vi`, `vim` | nvim |
| `ls`, `la`, `ll`, `lt` | exa / lsd (Liste, alle, lang, Baum) |
| `..`, `...` | Ein / zwei Ebenen hoch |
| `gs` `ga` `gc` `gp` `gpl` `gd` `gl` `gb` `gco` | git status/add/commit/push/pull/diff/log/branch/checkout |
| `gcl <url>` | git clone + cd |
| `glf` | git log mit fzf-Vorschau |
| `grepf <muster>` | grep + fzf |
| `mkcd <dir>` | Verzeichnis anlegen + hinein |
| `note [titel]` | Notiz in `~/.notes` (ohne Titel: Liste) |
| `killport <port>` | Prozess auf Port beenden |
| `pyvenv [name]` | Python-venv anlegen + aktivieren |
| `pi-ask "…"` / `pi-file <datei> "…"` | Pi-Agent befragen |
| `p` / `tm` | Git-Projekt aus `~/Projekte`, `~/projects`, `~/work`, `~/dev` per fzf öffnen (nvim / tmux) |
| `update` | System-Update (brew / yay / paru / pacman / apt) |

---

## 3. Neovim (LazyVim + eigene Mappings)

### Eigene Mappings (`nvim/lua/config/keymaps.lua`, `plugins/ui.lua`)

| Taste | Modus | Aktion |
|---|---|---|
| `<leader>Q` | n | Schließen ohne Speichern |
| `Ctrl+\` | n / t | Floating Terminal ein/aus (toggleterm) |
| `<leader>gg` | n | Lazygit (toggleterm) |
| `Ctrl+h/j/k/l` | n / t | Fenster wechseln (auch aus dem Terminal heraus) |
| `<leader>ai` | n / v | Pi: Frage stellen |
| `Ctrl+n` | n | Datei-Explorer (wie `<leader>e`) |

### Wichtige LazyVim-Defaults

**Dateien & Suche** (Snacks-Picker)

| Taste | Aktion |
|---|---|
| `<leader><leader>` / `<leader>ff` | Dateien finden |
| `<leader>/` / `<leader>sg` | Grep im Projekt |
| `<leader>,` / `<leader>fb` | Buffer wählen |
| `<leader>fr` | Zuletzt geöffnete Dateien |
| `<leader>e` | Datei-Explorer (Snacks) |
| `<leader>sh` | Hilfe durchsuchen |
| `<leader>sk` | Keymaps durchsuchen |
| `<leader>sr` | Suchen & Ersetzen (grug-far) |

**Buffer & Fenster**

| Taste | Aktion |
|---|---|
| `Shift+h` / `Shift+l` | Vorheriger / nächster Buffer |
| `<leader>bd` | Buffer schließen |
| `<leader>-` / `<leader>\|` | Fenster horizontal / vertikal teilen |
| `Ctrl+Pfeiltasten` | Fenstergröße ändern |

**Code / LSP**

| Taste | Aktion |
|---|---|
| `gd` | Gehe zu Definition |
| `gr` | Referenzen |
| `gI` | Implementierung |
| `K` | Hover-Doku |
| `<leader>ca` | Code Action |
| `<leader>cr` | Umbenennen |
| `<leader>cf` | Formatieren |
| `<leader>cd` | Zeilen-Diagnose (Float) |
| `]d` / `[d` | Nächste / vorherige Diagnose |
| `<leader>xx` | Diagnose-Liste (Trouble) |
| `gcc` / `gc` (visual) | Kommentar umschalten |

**Bewegen & Editieren**

| Taste | Aktion |
|---|---|
| `Alt+j` / `Alt+k` | Zeile (oder Auswahl) nach unten / oben verschieben |
| `s` | Flash: Sprung zu beliebiger Stelle |
| `S` | Flash: Treesitter-Auswahl |
| `]h` / `[h` | Nächster / vorheriger Git-Hunk |
| `<leader>ghs` / `<leader>ghr` | Hunk stagen / zurücksetzen |
| `<leader>gb` | Git blame (Zeile) |

**Sonstiges**

| Taste | Aktion |
|---|---|
| `<leader>l` | Lazy (Plugin-Manager) |
| `<leader>cm` | Mason (LSP/Formatter) |
| `Ctrl+s` | Speichern (alle Modi) |
| `<leader>qq` | Alles beenden |
| `<leader>qs` | Session wiederherstellen |
| `<leader>uw` / `<leader>ul` | Umbruch / Zeilennummern umschalten |
| `<leader>` (warten) | which-key zeigt alle Optionen |

---

## Hinweise

- **`Ctrl+/`** (LazyVim-Terminal) ist deaktiviert – stattdessen `Ctrl+\`.
- Kein tmux-Config vorhanden; `vim-tmux-navigator` wirkt also nur innerhalb von Neovim.
