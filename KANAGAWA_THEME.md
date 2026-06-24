# 🎨 Kanagawa Theme Setup

## Was wurde geändert:

Alle Dateien wurden auf das **Kanagawa Dragon** Theme umgestellt:

### 1. **init.lua** (Nvim)
- ✅ Colorscheme: `catppuccin` → `kanagawa`
- ✅ Lualine Theme: `catppuccin` → `kanagawa`
- ✅ Setup konfiguriert für "dragon" Variant

### 2. **ghostty-config** (Terminal)
- ✅ Farben aktualisiert auf Kanagawa Dragon Palette
- ✅ Background: `#181819`
- ✅ Foreground: `#dcd7ba`

### 3. **starship.toml** (Prompt)
- ✅ Alle Farben auf Kanagawa umgestellt
- ✅ Git Branch: `#938aa9` (Magenta)
- ✅ Directory: `#7fb4ca` (Cyan)
- ✅ Programmiersprachen mit Kanagawa Farben

### 4. **config.fish** (Shell)
- ✅ Syntax Colors auf Kanagawa Dragon
- ✅ Command: `#7e9cd8` (Blau)
- ✅ Error: `#c34043` (Rot)
- ✅ Comment: `#595959` (Grau)

### 5. **README.md** (Dokumentation)
- ✅ Themes Section aktualisiert
- ✅ Kanagawa Varianten erklärt

---

## 🎯 Kanagawa Farbpalette (Dragon)

| Farbe | Hex Code | Verwendung |
|-------|----------|-----------|
| Red | `#c34043` | Errors, Danger |
| Green | `#76946a` | Success, Code |
| Yellow | `#c0a36e` | Warnings, Tags |
| Blue | `#7e9cd8` | Commands, Keywords |
| Magenta | `#938aa9` | Git Branches |
| Cyan | `#7fb4ca` | Directories, Diff |
| Background | `#181819` | Dark bg |
| Foreground | `#dcd7ba` | Text |

---

## 🔄 Kanagawa Varianten

Du kannst zwischen 3 Varianten wechseln in `~/.config/nvim/init.lua`:

### Dragon (Aktuell)
Dunkel, warm, optimiert für lange Coding Sessions
```lua
theme = "dragon"
```

### Wave
Dunkel, kühl, mit sanften Graustufen
```lua
theme = "wave"
```

### Lotus
Hell, minimalistisch, für helle Umgebungen
```lua
theme = "lotus"
```

---

## ✨ Features

- 🎨 Konsistentes Theme über alle Tools
- 🌙 Dark-Mode optimiert (Dragon)
- 💻 Git Integration mit passenden Farben
- 🚀 Performance-optimiert
- 🔧 Leicht anpassbar

---

## 🔧 Anpassungen

### Einzelne Farbe ändern in nvim

`~/.config/nvim/init.lua`:

```lua
require("kanagawa").setup({
    colors = {
        theme = {
            all = {
                ui = "bg",
                float = "bg",
            },
        },
    },
    overrides = function(colors)
        return {
            -- Deine Anpassungen
        }
    end,
})
```

### Starship Farben anpassen

`~/.config/starship.toml`:

```toml
[directory]
style = "bold #7fb4ca"  # Ändere die Farbe

[git_branch]
style = "bold #938aa9"  # Ändere die Farbe
```

---

Viel Spaß mit dem Kanagawa Theme! 🎨
