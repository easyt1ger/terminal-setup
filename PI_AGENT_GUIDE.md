# 🤖 Pi Agent Integration Guide

Pi ist ein minimales, erweiterbares agentic coding agent von Earendil Inc. Dieses Setup integriert Pi sowohl in Nvim als auch im Terminal.

---

## 📥 Installation

Das setup.sh installiert Pi automatisch:

```bash
./setup.sh
# → Wähle "y" bei "Install Pi (agentic coding agent)?"
```

Oder manuell:

```bash
npm install -g @earendil-works/pi-coding-agent
```

---

## 🚀 Verwendung

### Im Terminal

```bash
# Start Pi Agent
pi

# Quick-Mode (einmaliger Prompt)
pi "Write a function that sorts an array"

# Mit Provider wechsel
pi --provider openai --model gpt-4o "Your prompt"
```

### In Nvim

```vim
<leader>ai    # Öffne Pi Prompt
              # Context = aktueller Buffer (+ Selection wenn markiert)
```

**Beispiel:**

```
1. Öffne Datei: main.py
2. Drücke: <leader>ai
3. Prompt: "Add error handling to this function"
4. Pi schreibt Code, integriert Changes automatisch
```

---

## 🔑 API Keys / Provider Setup

Pi unterstützt 15+ Provider. Wähle einen:

### Anthropic (Claude) - Empfohlen
```bash
export ANTHROPIC_API_KEY="sk-ant-..."
```

### OpenAI (GPT-4o, GPT-4)
```bash
export OPENAI_API_KEY="sk-..."
```

### Google Gemini
```bash
export GEMINI_API_KEY="..."
```

### xAI Grok
```bash
export XAI_API_KEY="..."
```

### DeepSeek
```bash
export DEEPSEEK_API_KEY="..."
```

### Subscription-basiert (kein Key nötig)
```bash
pi /login
# → Wähle: Claude Pro, ChatGPT Plus, oder GitHub Copilot
# → Browser öffnet sich für Authentication
```

---

## ⚙️ Konfiguration

### Nvim-Konfiguration (init.lua)

Die Standard-Konfiguration:

```lua
require("pi").setup({
    -- Pi wird automatisch erkannt
})
```

**Mit Custom Provider/Model:**

```lua
require("pi").setup({
    provider = "anthropic",    -- oder "openai", "gemini"
    model = "claude-opus",     -- Provider-spezifisches Model
})
```

**Verfügbare Provider:**
- `anthropic` (Claude)
- `openai` (GPT)
- `google` (Gemini)
- `xai` (Grok)
- `deepseek`
- `groq`
- `mistral`
- Und mehr (siehe `pi --list-models`)

---

## 💡 Workflow-Pattern

### Pattern 1: Edit & Ask (Schnell)
```
1. Öffne Datei in Nvim
2. <leader>ai → "Fix this bug"
3. Pi schreibt Code
4. Review & Save
```

### Pattern 2: Selection & Improve
```
1. Select Code-Block
2. <leader>ai → "Optimize this for performance"
3. Pi ersetzt nur Selection
4. Done!
```

### Pattern 3: Terminal Session
```
1. pi                          (öffne Agent)
2. /read file.py              (lade Datei)
3. "Add comprehensive tests"   (gib Prompt)
4. /write                      (speichere Changes)
5. exit                        (beende Session)
```

### Pattern 4: Full Project Context
```
1. pi
2. /context codebase          (lade ganzes Project)
3. "Refactor this module"      (komplexere Task)
4. Review, approve, save
```

---

## 🛠️ Fish Shell Integration

Zusätzliche Fish-Funktionen:

```fish
# Quick Pi ask (Terminal)
pi-ask "Your prompt here"

# Pi mit Datei-Context
pi-file file.py "What does this do?"
```

**Beispiele:**

```bash
# Schnell-Fragen beantworten
pi-ask "What's the Python syntax for..."

# Code-Spezifisch
pi-file src/api.js "Add rate limiting"
```

---

## 🎯 Best Practices

### Do's ✅
- Nutze `<leader>ai` für schnelle, fokussierte Änderungen
- Gib klare, spezifische Prompts
- Nutze Selection für kleine Code-Bereiche
- Review Changes vor dem Speichern
- Nutze Session Trees (pi /tree) für Experimentation

### Don'ts ❌
- Nutze Pi nicht für deine komplette Codebase ohne Context
- Nicht blind alle Changes akzeptieren
- Pi läuft mit deinen Shell-Permissions (Vorsicht!)
- Nicht für sensible Daten (PI, Credentials, etc.)

---

## 🔐 Sicherheit

### Wichtig!

Pi läuft mit deinen aktuellen Shell-Permissions. Das bedeutet:

- ✅ Pi kann Dateien lesen/schreiben wie du
- ⚠️ Keine eingebauten Permission-Checks
- 🔒 Bei sensiblen Projekten: Containerize Pi

### Containerization (Optional)

Pi unterstützt mehrere Sandboxing-Optionen:

```bash
# Docker
docker run -v $(pwd):/workspace pi

# Linux VM (Gondolin Extension)
# Siehe: pi.dev/packages/gondolin
```

---

## 🐛 Troubleshooting

### Problem: "command not found: pi"

```bash
# Überprüfe Installation
npm list -g @earendil-works/pi-coding-agent

# Installiere neu
npm install -g @earendil-works/pi-coding-agent
```

### Problem: API Key wird nicht erkannt

```bash
# Überprüfe Environment Variable
echo $ANTHROPIC_API_KEY

# Setze in ~/.config/fish/config.fish
set -gx ANTHROPIC_API_KEY "sk-ant-..."

# Oder per /login in Pi
pi /login
```

### Problem: <leader>ai funktioniert nicht in Nvim

```vim
:checkhealth pi
```

Falls pi.nvim nicht lädt:

```vim
:Lazy sync
:Lazy load pi.nvim
```

### Problem: Pi schreibt immer zu viel Code

Nutze kleinere Selections oder spezifischere Prompts:

```
Statt: "Write authentication"
Besser: "Write a login validation function that checks email format"
```

---

## 📚 Learning Resources

- **Pi Docs:** https://pi.dev
- **Earendil GitHub:** https://github.com/earendil-works/pi
- **pi.nvim GitHub:** https://github.com/pablopunk/pi.nvim
- **Agentic Coding:** https://www.saattrupdan.com/posts/2026-06-02-agentic-coding-v3-pi

---

## 🚀 Nächste Schritte

1. **Installiere Pi:** `npm install -g @earendil-works/pi-coding-agent`
2. **Setze API Key:** `export ANTHROPIC_API_KEY="sk-ant-..."`
3. **Teste im Terminal:** `pi "Hello, what's 2+2?"`
4. **Teste in Nvim:** Öffne Datei → `<leader>ai` → "Your prompt"
5. **Erkunde Extensions:** `pi /list-extensions`

---

Viel Spaß mit Pi! 🎉
