#!/bin/bash

# Uninstall & Reset Script
# Entfernt alle Konfigurationen und optional installierte Packages

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

# ==================== BACKUP CONFIGS ====================
backup_configs() {
    log_info "Creating backup of configurations..."
    
    BACKUP_DIR="$HOME/.config/nvim-backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    # Backup existing configs
    [ -d ~/.config/nvim ] && cp -r ~/.config/nvim "$BACKUP_DIR/nvim"
    [ -d ~/.config/fish ] && cp -r ~/.config/fish "$BACKUP_DIR/fish"
    [ -f ~/.config/starship.toml ] && cp ~/.config/starship.toml "$BACKUP_DIR/"
    [ -d ~/.config/ghostty ] && cp -r ~/.config/ghostty "$BACKUP_DIR/"
    
    log_success "Backup created at: $BACKUP_DIR"
    echo "  To restore: cp -r $BACKUP_DIR/* ~/.config/"
}

# ==================== REMOVE CONFIGS ====================
remove_configs() {
    log_info "Removing Nvim configuration..."
    
    if [ -d ~/.config/nvim ]; then
        rm -rf ~/.config/nvim
        log_success "Nvim config removed"
    else
        log_warning "Nvim config not found"
    fi
    
    log_info "Removing Fish configuration..."
    if [ -f ~/.config/fish/config.fish ]; then
        rm -f ~/.config/fish/config.fish
        log_success "Fish config removed"
    else
        log_warning "Fish config not found"
    fi
    
    log_info "Removing Starship configuration..."
    if [ -f ~/.config/starship.toml ]; then
        rm -f ~/.config/starship.toml
        log_success "Starship config removed"
    else
        log_warning "Starship config not found"
    fi
    
    log_info "Removing Ghostty configuration..."
    if [ -d ~/.config/ghostty ]; then
        rm -rf ~/.config/ghostty
        log_success "Ghostty config removed"
    else
        log_warning "Ghostty config not found"
    fi
}

# ==================== REMOVE NPM PACKAGES ====================
remove_npm_packages() {
    log_info "Would you like to uninstall npm packages? (y/n)"
    read -r response
    
    if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
        log_info "Uninstalling npm packages..."
        
        npm uninstall -g @earendil-works/pi-coding-agent 2>/dev/null || true
        npm uninstall -g prettier 2>/dev/null || true
        npm uninstall -g eslint 2>/dev/null || true
        npm uninstall -g typescript-language-server 2>/dev/null || true
        npm uninstall -g pyright 2>/dev/null || true
        
        log_success "npm packages uninstalled"
    fi
}

# ==================== REMOVE SYSTEM PACKAGES ====================
remove_system_packages() {
    log_info "Would you like to uninstall system packages? (y/n)"
    read -r response
    
    if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
        log_warning "This will uninstall: neovim, ghostty, starship, fish, fzf, ripgrep, exa, tmux, lazygit"
        log_warning "Continue? (y/n)"
        read -r confirm
        
        if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
            log_info "Skipping system package removal"
            return
        fi
        
        log_info "Uninstalling system packages..."
        
        if [ "$OS_TYPE" = "macos" ]; then
            # macOS with Homebrew
            brew uninstall neovim ghostty starship fish fzf ripgrep exa tmux lazygit -y 2>/dev/null || true
            log_success "Homebrew packages uninstalled"
            
        elif [ "$LINUX_DISTRO" = "arch" ]; then
            # Arch Linux
            sudo pacman -R neovim ghostty starship fish fzf ripgrep exa tmux lazygit -y 2>/dev/null || true
            log_success "Arch packages uninstalled"
            
        elif [ "$LINUX_DISTRO" = "debian" ]; then
            # Debian/Ubuntu
            sudo apt remove neovim ghostty fish fzf ripgrep exa tmux lazygit -y 2>/dev/null || true
            sudo apt autoremove -y 2>/dev/null || true
            log_success "apt packages uninstalled"
        fi
    fi
}

# ==================== RESET SHELL ====================
reset_shell() {
    log_info "Would you like to reset shell to default? (y/n)"
    read -r response
    
    if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
        log_info "Resetting default shell..."
        
        if [ "$OS_TYPE" = "macos" ]; then
            chsh -s /bin/zsh
            log_success "Shell reset to /bin/zsh"
        else
            chsh -s /bin/bash
            log_success "Shell reset to /bin/bash"
        fi
    fi
}

# ==================== CLEANUP ====================
cleanup() {
    log_info "Cleaning up temporary directories..."
    
    # Remove undodir
    [ -d ~/.vim/undodir ] && rm -rf ~/.vim/undodir && log_success "Undo directory removed"
    
    # Remove notes
    log_info "Remove ~/.notes directory? (y/n)"
    read -r response
    if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
        [ -d ~/.notes ] && rm -rf ~/.notes && log_success "Notes removed"
    fi
}

# ==================== PRINT SUMMARY ====================
print_summary() {
    echo ""
    echo -e "${GREEN}======================================${NC}"
    echo -e "${GREEN}  Uninstall Complete!${NC}"
    echo -e "${GREEN}======================================${NC}"
    echo ""
    echo "What was removed:"
    echo "  • Nvim configuration (~/.config/nvim)"
    echo "  • Fish configuration (~/.config/fish/config.fish)"
    echo "  • Starship configuration (~/.config/starship.toml)"
    echo "  • Ghostty configuration (~/.config/ghostty)"
    echo ""
    echo "Optional (if selected):"
    echo "  • System packages (neovim, ghostty, starship, fish, etc.)"
    echo "  • npm packages (pi, prettier, eslint, etc.)"
    echo "  • Default shell reset"
    echo ""
    echo "Backup location:"
    echo "  • Check output above for backup directory"
    echo ""
    echo "To restore from backup:"
    echo "  cp -r /path/to/backup/* ~/.config/"
    echo ""
}

# ==================== MAIN EXECUTION ====================
main() {
    echo ""
    log_warning "=== NVIM SETUP UNINSTALLER ==="
    log_warning "This will remove your nvim configuration!"
    echo ""
    log_info "Create backup first? (recommended: y/n)"
    read -r backup_response
    
    if [ "$backup_response" = "y" ] || [ "$backup_response" = "Y" ]; then
        backup_configs
    else
        log_warning "No backup will be created!"
    fi
    
    echo ""
    log_warning "Proceed with uninstallation? (y/n)"
    read -r proceed
    
    if [ "$proceed" != "y" ] && [ "$proceed" != "Y" ]; then
        log_info "Cancelled. Nothing was removed."
        exit 0
    fi
    
    echo ""
    remove_configs
    remove_npm_packages
    remove_system_packages
    reset_shell
    cleanup
    
    print_summary
}

# Run main function
main
