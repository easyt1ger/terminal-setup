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

log_info "Detected OS: ${OS_TYPE}"
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
        log_info "Using pacman as package manager"
        # Update pacman database
        sudo pacman -Sy
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
        brew install black
        brew install prettier
        
        # Optional: Python, Node for better LSP support
        # brew install python
        # brew install node
        # brew install rust
    elif [ "$LINUX_DISTRO" = "arch" ]; then
        # Arch Linux with pacman
        sudo pacman -S --noconfirm \
            neovim \
            fish \
            git \
            fzf \
            ripgrep \
            eza \
            tmux \
            lazygit \
            python \
            python-pip \
            nodejs \
            npm \
            base-devel
        
        # Starship via AUR or direct install
        log_info "Installing Starship..."
        if ! command -v starship &> /dev/null; then
            # Direct install
            curl -sS https://starship.rs/install.sh | sh -s -- --bin-dir ~/.local/bin
        fi
        
        # Ghostty needs to be built from source on Arch
        log_info "Ghostty on Arch: Either install from AUR (paru/yay) or build from source"
        log_info "  paru -S ghostty"
        log_info "  or yay -S ghostty"
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
        curl -sS https://starship.rs/install.sh | sh
        
        # Language formatters
        pip3 install black isort pylint
        npm install -g prettier
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
copy_configs() {
    log_info "Copying configuration files..."
    
    # Script directory
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    
    # Nvim (LazyVim-basierte Verzeichnisstruktur)
    if [ -d "$SCRIPT_DIR/nvim" ]; then
        cp -r "$SCRIPT_DIR/nvim/." ~/.config/nvim/
        log_success "Nvim config installed (LazyVim)"
    else
        log_warning "nvim/ directory not found in script directory"
    fi
    
    # Fish
    if [ -f "$SCRIPT_DIR/config.fish" ]; then
        cp "$SCRIPT_DIR/config.fish" ~/.config/fish/
        log_success "Fish config installed"
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
        cp "$SCRIPT_DIR/ghostty-config" ~/.config/ghostty/config
        log_success "Ghostty config installed"
    else
        log_warning "ghostty-config not found in script directory"
    fi
}

# ==================== SET SHELL ====================
set_shell() {
    log_info "Setting Fish as default shell..."
    
    if [ "$OS_TYPE" = "macos" ]; then
        FISH_PATH="/opt/homebrew/bin/fish"
    else
        # Linux
        FISH_PATH="/usr/bin/fish"
    fi
    
    if [ "$SHELL" != "$FISH_PATH" ]; then
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
        brew install shfmt
    elif [ "$LINUX_DISTRO" = "arch" ]; then
        sudo pacman -S --noconfirm \
            shfmt \
            shellcheck \
            prettier
    else
        sudo apt install -y shellcheck shfmt
    fi
    
    npm install -g prettier eslint

    log_info "Python-Formatter (black, isort, pylint) werden via Mason in Neovim installiert"
    log_success "Formatters installed"
}

# ==================== INSTALL PI (Agentic Coding Agent) ====================
install_pi() {
    log_info "Would you like to install Pi (agentic coding agent)? (y/n)"
    read -r response
    
    if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
        log_info "Installing Pi coding agent..."
        
        if ! command -v npm &> /dev/null; then
            log_error "npm not found. Install Node.js first."
            return 1
        fi
        
        # Install Pi globally
        npm install -g @earendil-works/pi-coding-agent
        
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
    echo "  • <leader>fg = Live grep"
    echo "  • <C-\\> = Toggle terminal"
    echo "  • <C-h/j/k/l> = Navigate splits"
    echo ""
    echo "Useful Fish functions:"
    echo "  • p = Project picker"
    echo "  • tm = Tmux session picker"
    echo "  • gcl = Git clone and enter"
    echo "  • note = Quick notes"
    echo ""
    echo "Troubleshooting:"
    echo "  • If plugins don't load: :Lazy sync in nvim"
    echo "  • If LSP doesn't work: :LspInfo in nvim"
    echo "  • Check configs: ~/.config/{nvim,fish,starship.toml,ghostty/config}"
    echo ""
}

# ==================== MAIN EXECUTION ====================
main() {
    log_info "Starting setup for ${OS_TYPE}..."
    echo ""
    
    install_package_manager
    install_dependencies
    create_directories
    copy_configs
    set_shell
    install_formatters
    install_pi

    print_summary
}

# Run main function
main
