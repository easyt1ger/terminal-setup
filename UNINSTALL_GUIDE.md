# 🗑️ Uninstall & Reset Guide

Dieses Guide erklärt, wie du dein Nvim Setup komplett resetten kannst.

---

## 🚀 Quick Uninstall

```bash
# Mach das Script ausführbar
chmod +x uninstall.sh

# Starten
./uninstall.sh
```

Das Script fragt dich nach jedem Schritt und warnt vor Änderungen.

---

## 📋 Was wird entfernt?

### Automatisch entfernt:
- ✅ `~/.config/nvim/` - Nvim Config + Plugins
- ✅ `~/.config/fish/config.fish` - Fish Config
- ✅ `~/.config/starship.toml` - Starship Prompt
- ✅ `~/.config/ghostty/` - Ghostty Terminal Config

### Optional (auf Anfrage):
- 📦 npm Packages (pi, prettier, eslint, pyright, etc.)
- 🖥️ System Packages (neovim, ghostty, starship, fish, etc.)
- 🐚 Shell reset zu Standard (zsh/bash)
- 📝 ~/.notes Verzeichnis

---

## 🔄 Schritte

### 1. Backup erstellen (empfohlen)
```
→ Frage: "Create backup first?"
  ✅ Antworte "y" für Sicherheit
  → Backup wird erstellt in: ~/.config/nvim-backup-TIMESTAMP/
```

### 2. Bestätigen
```
→ Frage: "Proceed with uninstallation?"
  ✅ Antworte "y" zum Fortfahren
  ❌ Antworte "n" zum Abbrechen
```

### 3. npm Packages (optional)
```
→ Frage: "Would you like to uninstall npm packages?"
  ✅ Ja: Entfernt pi, prettier, eslint, pyright
  ❌ Nein: Lässt alle npm Packages
```

### 4. System Packages (optional)
```
→ Frage: "Would you like to uninstall system packages?"
  ✅ Ja: Entfernt neovim, ghostty, starship, fish, etc.
  ❌ Nein: Lässt alle installiert
```

### 5. Shell reset (optional)
```
→ Frage: "Would you like to reset shell to default?"
  ✅ macOS: Setzt auf /bin/zsh
  ✅ Linux: Setzt auf /bin/bash
```

### 6. Aufräumen
```
→ Entfernt ~/.vim/undodir
→ Fragt ob ~/.notes gelöscht werden soll
```

---

## 💾 Backup & Restore

### Backup wurde erstellt
```
Backup location: ~/.config/nvim-backup-20260624-143022/

Inhalte:
  • nvim/        - komplette Nvim Config
  • fish/        - Fish Shell Config
  • starship.toml - Starship Prompt
  • ghostty/     - Ghostty Config
```

### Wiederherstellen aus Backup
```bash
# Alles zurück
cp -r ~/.config/nvim-backup-20260624-143022/* ~/.config/

# Oder einzeln
cp -r ~/.config/nvim-backup-20260624-143022/nvim ~/.config/
cp ~/.config/nvim-backup-20260624-143022/starship.toml ~/.config/
```

---

## 🔧 Manuelle Uninstallation

Falls das Script nicht funktioniert, kann man auch manuell löschen:

### Configs löschen
```bash
# Nvim
rm -rf ~/.config/nvim

# Fish
rm -f ~/.config/fish/config.fish

# Starship
rm -f ~/.config/starship.toml

# Ghostty
rm -rf ~/.config/ghostty
```

### npm Packages deinstallieren
```bash
npm uninstall -g @earendil-works/pi-coding-agent
npm uninstall -g prettier eslint
npm uninstall -g typescript-language-server pyright
```

### System Packages deinstallieren

#### macOS
```bash
brew uninstall neovim ghostty starship fish fzf ripgrep exa tmux lazygit
```

#### Arch Linux
```bash
sudo pacman -R neovim ghostty starship fish fzf ripgrep exa tmux lazygit
```

#### Debian/Ubuntu
```bash
sudo apt remove neovim ghostty fish fzf ripgrep exa tmux lazygit
sudo apt autoremove -y
```

### Shell zurück setzen

#### macOS
```bash
chsh -s /bin/zsh
```

#### Linux
```bash
chsh -s /bin/bash
```

---

## ❓ FAQ

### F: Kann ich nur Teile entfernen?
**A:** Ja! Das Script fragt bei jedem großen Schritt. Du kannst:
- Configs entfernen, aber Packages behalten
- Packages deinstallieren, aber Configs behalt
- Alles entfernen

### F: Wo ist mein Backup?
**A:** Im Output am Ende findest du die Backup-Location, z.B.:
```
Backup created at: /Users/you/.config/nvim-backup-20260624-143022
```

### F: Kann ich von Backup wiederherstellen?
**A:** Ja, jederzeit:
```bash
cp -r ~/.config/nvim-backup-*/nvim ~/.config/
```

### F: Was wenn ich alles versehentlich gelöscht habe?
**A:** 
1. Check ob Backup existiert: `ls ~/.config/nvim-backup-*/`
2. Wiederherstellen: `cp -r ~/.config/nvim-backup-*/nvim ~/.config/`
3. Falls kein Backup: Setup einfach neu mit `./setup.sh`

### F: Funktioniert das auf allen OS?
**A:** Ja! Das Script erkennt automatisch:
- macOS (Homebrew)
- Arch Linux (pacman)
- Debian/Ubuntu (apt)

### F: Brauche ich Sudo?
**A:** Nur wenn Packages deinstalliert werden (System-level).

---

## 🔄 Reset & Neustart

Nach Uninstall kannst du:

### Option 1: Frischer Start
```bash
# Nur löschen, nichts neu installieren
./uninstall.sh
# → Alle "y" außer "uninstall system packages"
```

### Option 2: Alles raus & Neu starten
```bash
# Komplette Neuinstallation
./uninstall.sh    # Alles deinstallieren
./setup.sh        # Neu installieren
```

### Option 3: Config-Reset (Plugins behalten)
```bash
# Nur Configs löschen
rm -rf ~/.config/nvim

# Plugins bleiben in ~/.local/share/nvim/
# Beim nächsten nvim-Start neu laden

# Oder manuell resyncen
nvim
:Lazy sync
```

---

## 📞 Troubleshooting

### Problem: "Permission denied" beim Löschen
```bash
sudo ./uninstall.sh
# oder
sudo rm -rf ~/.config/nvim  # manuell
```

### Problem: Script findet nicht alle Packages
```bash
# Manuell checken was noch da ist
npm list -g | grep -E "pi|prettier|eslint"
which pi
which ghostty
```

### Problem: Shell wird nicht geändert
```bash
# Manuell setzen
chsh -s /bin/bash     # Linux
chsh -s /bin/zsh      # macOS
```

---

## ✅ Checkliste nach Uninstall

Nach erfolgreicher Deinstallation:

- [ ] Configs gelöscht? `ls ~/.config/nvim` sollte nicht existieren
- [ ] Shell zurückgesetzt? `echo $SHELL` sollte /bin/bash oder /bin/zsh sein
- [ ] Backup vorhanden? `ls ~/.config/nvim-backup-*/` sollte existieren
- [ ] Terminal neustarten
- [ ] Testen: `nvim` sollte vanilla Nvim sein (ohne Plugins)

---

Viel Erfolg beim Resetten! 🎉
