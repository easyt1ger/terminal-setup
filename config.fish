# Fish Shell Configuration
# ~/.config/fish/config.fish

# ==================== EDITOR ====================
set -gx EDITOR nvim
set -gx VISUAL nvim

# ==================== ENVIRONMENT ====================
# Terminal
set -gx TERM ghostty

# FZF Integration
if type -q fzf
    fzf --fish | source
end

# ==================== PATHS ====================
# Homebrew (macOS)
if test -d /opt/homebrew/bin
    set -gx PATH /opt/homebrew/bin $PATH
end

# User local bin
if test -d ~/.local/bin
    set -gx PATH ~/.local/bin $PATH
end

# Cargo (Rust)
if test -d ~/.cargo/bin
    set -gx PATH ~/.cargo/bin $PATH
end

# ==================== ALIASES ====================
# Nvim (v ist als Funktion weiter unten definiert)
alias vi nvim
alias vim nvim
alias vimdiff "nvim -d"

# File operations
if type -q exa
    alias ls exa
    alias la "exa -la"
    alias ll "exa -lh"
    alias lt "exa -lhT"
else if type -q lsd
    alias ls lsd
    alias la "lsd -la"
    alias ll "lsd -lh"
    alias lt "lsd --tree"
else
    alias la "ls -la"
    alias ll "ls -lh"
end

# Directory
alias .. "cd .."
alias ... "cd ../.."
alias cd.. "cd .."

# Git shortcuts
alias gs "git status"
alias ga "git add"
alias gc "git commit"
alias gp "git push"
alias gpl "git pull"
alias gd "git diff"
alias gl "git log --oneline"
alias gb "git branch"
alias gco "git checkout"

# System
alias sudo "sudo "
alias cp "cp -i"
alias mv "mv -i"
alias mkdir "mkdir -p"
alias grep "grep --color"

# ==================== FUNCTIONS ====================
# Quick nvim + fzf
function v
    if test (count $argv) -gt 0
        nvim $argv
    else
        # Open with fzf if no arguments
        set -l file (fzf --preview 'head -20 {}')
        test -n "$file" && nvim "$file"
    end
end

# CD + LS
function cd
    builtin cd $argv
    and ls
end

# Make directory and cd into it
function mkcd
    mkdir -p $argv
    cd $argv
end

# Git-Projekte in den üblichen Verzeichnissen auflisten
function __project_dirs
    set -l roots
    for d in ~/Projekte ~/projects ~/work ~/dev
        test -d $d && set -a roots $d
    end
    test (count $roots) -eq 0 && return 1
    find $roots -maxdepth 3 -type d -name .git -prune 2>/dev/null | sed 's|/\.git$||'
end

# Quick project navigation
function p
    set -l project (__project_dirs | fzf --preview 'ls -la {}' --preview-window right:30%)
    test -n "$project" && cd "$project" && nvim
end

# Git clone and cd
function gcl
    set -l url $argv[1]
    set -l dirname (basename $url .git)
    git clone $url $dirname && cd $dirname
end

# Tmux project session
function tm
    set -l session (__project_dirs | fzf --preview 'ls -la {}')
    test -n "$session" && tmux new-session -A -s (basename $session) -c $session
end

# Git log with fzf
function glf
    git log --oneline | fzf --preview 'git show {1}' | cut -d' ' -f1 | xargs git show
end

# Grep with fzf
function grepf
    grep -r $argv --exclude-dir=.git --exclude-dir=node_modules --exclude='*.swp' 2>/dev/null | \
    fzf --preview 'echo {} | cut -d: -f1-2'
end

# Quick notes
function note
    set -l notedir ~/.notes
    mkdir -p $notedir
    
    if test (count $argv) -eq 0
        ls -lt $notedir | head -20
    else
        set -l filename $notedir/(date +%Y%m%d-%H%M%S)-$argv.md
        nvim $filename
    end
end

# Update system
function update
    if type -q brew
        echo "Updating Homebrew..."
        brew update && brew upgrade
    else if type -q yay
        echo "Updating System (yay)..."
        yay -Syu
    else if type -q paru
        echo "Updating System (paru)..."
        paru -Syu
    else if type -q pacman
        echo "Updating System (pacman)..."
        sudo pacman -Syu
    else if type -q apt
        echo "Updating System (apt)..."
        sudo apt update && sudo apt upgrade -y
    else
        echo "Kein unterstützter Paketmanager gefunden"
        return 1
    end
end

# Kill port
function killport
    if test -z "$argv"
        echo "Usage: killport <port>"
        return 1
    end
    
    switch (uname -s)
        case Darwin
            lsof -ti:$argv[1] | xargs kill -9
        case Linux
            fuser -k $argv[1]/tcp
    end
end

# Python venv quick setup
function pyvenv
    set -l venv_name venv
    test (count $argv) -gt 0 && set venv_name $argv[1]

    python3 -m venv $venv_name
    and source $venv_name/bin/activate.fish
    and echo "Virtual environment '$venv_name' created and activated!"
end

# Quick Pi commands
function pi-ask
    set -l prompt $argv
    pi --prompt "$prompt"
end

function pi-file
    set -l file $argv[1]
    set -l prompt $argv[2..-1]
    pi --file "$file" --prompt "$prompt"
end

# ==================== STARSHIP INTEGRATION ====================
if type -q starship
    starship init fish | source
end

# ==================== GREETING ====================
function fish_greeting
    # Disable default greeting (Starship handles prompt)
end

# ==================== COLORS & THEME ====================
# Kanagawa Dragon colors for Fish syntax highlighting
set fish_color_autosuggestion 595959
set fish_color_command 7e9cd8
set fish_color_comment 595959
set fish_color_end c34043
set fish_color_error c34043
set fish_color_operator 7e9cd8
set fish_color_param 7e9cd8
set fish_color_quote c8c093
set fish_color_redirection 7e9cd8
set fish_color_search_match --background=2b2d2e

# ==================== STARTUP CHECKS ====================
# Warn if common tools missing
if not type -q nvim
    echo "⚠️  neovim not found. Install: sudo pacman -S neovim (Arch) / brew install neovim (macOS)"
end

if not type -q fzf
    echo "⚠️  fzf not found. Install: sudo pacman -S fzf (Arch) / brew install fzf (macOS)"
end

if not type -q git
    echo "⚠️  git not found. Install: sudo pacman -S git (Arch) / brew install git (macOS)"
end
