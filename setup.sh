#!/bin/bash

# Nvim + Terminal Setup Script
# Für macOS und Linux

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${BLUE}➜${NC} $1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Globale npm-Pakete installieren. Ist das globale Prefix (z. B. /usr) nicht
# beschreibbar, wird nach ~/.local installiert (Binaries in ~/.local/bin).
npm_global() {
    if ! command -v npm &> /dev/null; then
        log_warning "npm not found, skipping: $*"
        return 0
    fi
    if [ -w "$(npm config get prefix)/lib" ]; then
        npm install -g "$@"
    else
        mkdir -p "$HOME/.local"
        npm install -g --prefix "$HOME/.local" "$@"
    fi
}

# Detect OS
OS="$(uname -s)"
case "${OS}" in
    Darwin*)
        OS_TYPE="macos"
        ;;
    Linux*)
        OS_TYPE="linux"
        # Detect Linux distribution
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            if [ "$ID" = "arch" ] || [ "$ID_LIKE" = "arch" ]; then
                LINUX_DISTRO="arch"
            elif [ "$ID" = "ubuntu" ] || [ "$ID" = "debian" ]; then
                LINUX_DISTRO="debian"
            else
                LINUX_DISTRO="unknown"
            fi
        else
            LINUX_DISTRO="unknown"
        fi
        ;;
    *)
        log_error "Unsupported operating system: ${OS}"
        exit 1
        ;;
esac

# Omarchy (Arch-basiert, verwaltet Themes und Terminal-Konfiguration selbst) erkennen
IS_OMARCHY=0
if [ "$OS_TYPE" = "linux" ]; then
    if [ -d "$HOME/.local/share/omarchy" ] || [ -d /usr/share/omarchy ] \
        || grep -qi omarchy /etc/os-release 2>/dev/null; then
        IS_OMARCHY=1
        LINUX_DISTRO="arch"
    fi
fi

# Unter Omarchy kein "pacman -Syu": Updates laufen über Omarchys eigenes Update
# (inklusive Snapshot). Vorher "omarchy-update" ausführen.
PACMAN_FLAGS="-Syu"
if [ "$IS_OMARCHY" = 1 ]; then
    PACMAN_FLAGS="-S"
fi

log_info "Detected OS: ${OS_TYPE}"
if [ "$IS_OMARCHY" = 1 ]; then
    log_info "Omarchy erkannt: Theme wird nicht angefasst, Login-Shell bleibt bash"
fi
if [ "$OS_TYPE" = "linux" ]; then
    log_info "Detected Linux distro: ${LINUX_DISTRO}"
fi

# ==================== INSTALL BREW / PACMAN / APT ====================
install_package_manager() {
    if [ "$OS_TYPE" = "macos" ]; then
        if ! command -v brew &> /dev/null; then
            log_info "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            log_success "Homebrew installed"
        else
            log_success "Homebrew already installed"
        fi
    elif [ "$LINUX_DISTRO" = "arch" ]; then
        # Kein "pacman -Sy" allein (Teil-Update!), das System wird in
        # install_dependencies mit -Syu aktualisiert
        log_info "Using pacman as package manager"
    elif [ "$LINUX_DISTRO" = "debian" ]; then
        sudo apt update
        log_info "Using apt as package manager"
    else
        log_error "Unsupported Linux distribution"
        exit 1
    fi
}

# ==================== INSTALL DEPENDENCIES ====================
install_dependencies() {
    log_info "Installing dependencies..."

    if [ "$OS_TYPE" = "macos" ]; then
        # macOS with Homebrew
        brew install neovim
        brew install ghostty
        brew install starship
        brew install fish
        brew install git
        brew install fzf
        brew install ripgrep
        brew install eza
        brew install tmux
        brew install lazygit
        brew install stylua
        brew install prettier
        
        # Optional: Python, Node for better LSP support
        # brew install python
        # brew install node
        # brew install rust
    elif [ "$LINUX_DISTRO" = "arch" ]; then
        # Arch Linux with pacman
        # -Syu: System aktualisieren + installieren, --needed: Vorhandenes überspringen
        sudo pacman $PACMAN_FLAGS --needed --noconfirm \
            neovim \
            fish \
            git \
            fzf \
            ripgrep \
            eza \
            tmux \
            lazygit \
            starship \
            ghostty \
            python \
            nodejs \
            npm \
            base-devel
    else
        # Linux Debian/Ubuntu with apt
        sudo apt update
        sudo apt install -y \
            neovim \
            fish \
            git \
            fzf \
            ripgrep \
            eza \
            tmux \
            lazygit \
            python3-pip \
            nodejs \
            npm
        
        # Starship
        if ! command -v starship &> /dev/null; then
            curl -sS https://starship.rs/install.sh | sh
        fi
    fi

    log_success "Dependencies installed"
}

# ==================== CREATE CONFIG DIRECTORIES ====================
create_directories() {
    log_info "Creating configuration directories..."
    
    mkdir -p ~/.config/nvim
    mkdir -p ~/.config/fish
    mkdir -p ~/.config/starship
    mkdir -p ~/.config/ghostty
    mkdir -p ~/.vim/undodir
    mkdir -p ~/.notes
    
    log_success "Directories created"
}

# ==================== COPY CONFIG FILES ====================
# Theme-Teile sind in den Configs mit THEME-BEGIN/THEME-END markiert und werden
# unter Omarchy ausgelassen (Omarchy verwaltet Themes selbst).
strip_theme() {
    sed '/THEME-BEGIN/,/THEME-END/d' "$1"
}

backup_configs() {
    [ "$IS_OMARCHY" = 1 ] || return 0
    BACKUP_DIR="$HOME/.config/terminal-setup-backup-$(date +%Y%m%d-%H%M%S)"
    log_info "Omarchy: sichere bestehende Configs nach $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
    [ -d ~/.config/nvim ] && cp -r ~/.config/nvim "$BACKUP_DIR/nvim"
    [ -d ~/.config/ghostty ] && cp -r ~/.config/ghostty "$BACKUP_DIR/ghostty"
    [ -f ~/.config/starship.toml ] && cp ~/.config/starship.toml "$BACKUP_DIR/"
    [ -f ~/.config/fish/config.fish ] && cp ~/.config/fish/config.fish "$BACKUP_DIR/"
    return 0
}

copy_configs() {
    log_info "Copying configuration files..."

    # Script directory
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

    # Nvim (LazyVim-basierte Verzeichnisstruktur)
    if [ -d "$SCRIPT_DIR/nvim" ]; then
        if [ "$IS_OMARCHY" = 1 ]; then
            # Mit Omarchys vorhandener Config zusammenführen, Theme-Datei auslassen
            (cd "$SCRIPT_DIR/nvim" && tar cf - --exclude='lua/plugins/colorscheme.lua' .) \
                | tar xf - -C ~/.config/nvim
            log_success "Nvim config merged (ohne Theme)"
        else
            cp -r "$SCRIPT_DIR/nvim/." ~/.config/nvim/
            log_success "Nvim config installed (LazyVim)"
        fi
    else
        log_warning "nvim/ directory not found in script directory"
    fi

    # Fish
    if [ -f "$SCRIPT_DIR/config.fish" ]; then
        if [ "$IS_OMARCHY" = 1 ]; then
            strip_theme "$SCRIPT_DIR/config.fish" > ~/.config/fish/config.fish
            log_success "Fish config installed (ohne Theme)"
        else
            cp "$SCRIPT_DIR/config.fish" ~/.config/fish/
            log_success "Fish config installed"
        fi
    else
        log_warning "config.fish not found in script directory"
    fi

    # Starship
    if [ -f "$SCRIPT_DIR/starship.toml" ]; then
        cp "$SCRIPT_DIR/starship.toml" ~/.config/starship.toml
        log_success "Starship config installed"
    else
        log_warning "starship.toml not found in script directory"
    fi

    # Ghostty
    if [ -f "$SCRIPT_DIR/ghostty-config" ]; then
        if [ "$IS_OMARCHY" = 1 ]; then
            # Omarchys Config bleibt bestehen; eigene Einstellungen kommen als
            # markierter Block ans Ende (später gesetzte Werte gewinnen).
            GHOSTTY_CFG=~/.config/ghostty/config
            BLOCK_START="# >>> terminal-setup >>>"
            BLOCK_END="# <<< terminal-setup <<<"
            touch "$GHOSTTY_CFG"
            sed -i "/$BLOCK_START/,/$BLOCK_END/d" "$GHOSTTY_CFG"
            {
                echo "$BLOCK_START"
                strip_theme "$SCRIPT_DIR/ghostty-config" | grep -v '^macos-'
                echo "$BLOCK_END"
            } >> "$GHOSTTY_CFG"
            log_success "Ghostty config als Block ergänzt (ohne Theme)"
        else
            cp "$SCRIPT_DIR/ghostty-config" ~/.config/ghostty/config
            log_success "Ghostty config installed"
        fi
    else
        log_warning "ghostty-config not found in script directory"
    fi
}

# ==================== SET SHELL ====================
set_shell() {
    if [ "$IS_OMARCHY" = 1 ]; then
        log_info "Omarchy: bash bleibt Login-Shell, fish startet über Ghostty (command = /usr/bin/fish)"
        return 0
    fi

    log_info "Setting Fish as default shell..."
    
    FISH_PATH="$(command -v fish || true)"
    if [ -z "$FISH_PATH" ]; then
        log_warning "fish not found, skipping default shell change"
        return 0
    fi

    # Login-Shell aus der Benutzerdatenbank lesen ($SHELL hängt vom Terminal ab)
    if [ "$OS_TYPE" = "macos" ]; then
        LOGIN_SHELL="$(dscl . -read "/Users/$USER" UserShell | awk '{print $2}')"
    else
        LOGIN_SHELL="$(getent passwd "$USER" | cut -d: -f7)"
    fi

    if [ "$(basename "$LOGIN_SHELL")" != "fish" ]; then
        chsh -s "$FISH_PATH"
        log_success "Fish set as default shell"
    else
        log_success "Fish already default shell"
    fi
}

# ==================== INSTALL FORMATTERS ====================
install_formatters() {
    log_info "Installing additional formatters..."
    
    if [ "$OS_TYPE" = "macos" ]; then
        brew install shfmt shellcheck eslint
    elif [ "$LINUX_DISTRO" = "arch" ]; then
        sudo pacman -S --needed --noconfirm \
            shfmt \
            shellcheck \
            prettier \
            eslint
    else
        sudo apt install -y shellcheck shfmt
        npm_global prettier eslint
    fi

    log_info "Python-Formatter (black, isort, pylint) werden via Mason in Neovim installiert"
    log_success "Formatters installed"
}

# ==================== INSTALL PI (Agentic Coding Agent) ====================
install_pi() {
    log_info "Would you like to install Pi (agentic coding agent)? (y/n)"
    read -r response || response="n"
    
    if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
        log_info "Installing Pi coding agent..."
        
        if ! command -v npm &> /dev/null; then
            log_error "npm not found. Install Node.js first."
            return 0
        fi

        # Install Pi globally
        npm_global @earendil-works/pi-coding-agent
        
        log_success "Pi coding agent installed"
        log_info "Use: pi in terminal or <leader>ai in Nvim"
    fi
}

# ==================== SUMMARY ====================
print_summary() {
    echo ""
    echo -e "${GREEN}======================================${NC}"
    echo -e "${GREEN}  Setup Complete! 🎉${NC}"
    echo -e "${GREEN}======================================${NC}"
    echo ""
    echo "Configuration files installed:"
    echo "  • ~/.config/nvim/ (LazyVim-Struktur)"
    echo "  • ~/.config/fish/config.fish"
    echo "  • ~/.config/starship.toml"
    echo "  • ~/.config/ghostty/config"
    echo ""
    echo "Next steps:"
    echo "  1. Close and reopen your terminal"
    echo "  2. Run: nvim"
    echo "  3. LazyVim installiert Plugins automatisch beim ersten Start"
    echo "  4. LSP-Server werden via Mason installiert: :Mason in nvim"
    echo ""
    echo "Quick keybindings:"
    echo "  • <leader> = space"
    echo "  • <leader>ff = Find files"
    echo "  • <leader>/ = Live grep"
    echo "  • <C-\\> = Toggle terminal"
    echo "  • <C-h/j/k/l> = Navigate Nvim windows"
    echo "  • Ctrl+Alt+h/j/k/l = Navigate Ghostty splits"
    echo "  • Full list: KEYBINDINGS.md"
    echo ""
    echo "Useful Fish functions:"
    echo "  • p = Project picker"
    echo "  • tm = Tmux session picker"
    echo "  • gcl = Git clone and enter"
    echo "  • note = Quick notes"
    echo ""
    if [ "$IS_OMARCHY" = 1 ]; then
        echo "Omarchy-Hinweise:"
        echo "  • Theme wurde nicht angefasst (Farben kommen von Omarchy)"
        echo "  • Alte Configs liegen in ~/.config/terminal-setup-backup-*"
        echo "  • Ghostty-Binds gegen Hyprland-Binds (~/.config/hypr/) prüfen"
        echo ""
    fi
    echo "Troubleshooting:"
    echo "  • If plugins don't load: :Lazy sync in nvim"
    echo "  • If LSP doesn't work: :LspInfo / :Mason in nvim"
    echo "  • Check configs: ~/.config/{nvim,fish,starship.toml,ghostty/config}"
    echo ""
}

# ==================== MAIN EXECUTION ====================
main() {
    log_info "Starting setup for ${OS_TYPE}..."
    echo ""
    
    install_package_manager
    install_dependencies
    backup_configs
    create_directories
    copy_configs
    set_shell
    install_formatters
    install_pi

    print_summary
}

# Run main function
main
