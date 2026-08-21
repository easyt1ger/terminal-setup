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
# Nvim
alias v nvim
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

# Quick project navigation
function p
    set -l project (find ~/{projects,work,dev} -maxdepth 2 -type d -name ".git" -parent 2>/dev/null | \
                    sed 's|/.git||' | \
                    fzf --preview 'ls -la {} 2>/dev/null' --preview-window right:30% 2>/dev/null)
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
    set -l session (find ~/{projects,work,dev} -maxdepth 2 -type d -name ".git" -parent 2>/dev/null | \
                    sed 's|/.git||' | \
                    fzf --preview 'ls -la {} 2>/dev/null' 2>/dev/null)
    test -n "$session" && tmux new-session -s (basename $session) -c $session
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
    switch (uname -s)
        case Darwin
            echo "Updating Homebrew..."
            brew update && brew upgrade
        case Linux
            echo "Updating System..."
            sudo apt update && sudo apt upgrade -y
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
    if test -z "$argv"
        set -l venv_name "venv"
    else
        set -l venv_name $argv[1]
    end
    
    python3 -m venv $venv_name
    source $venv_name/bin/activate.fish
    echo "Virtual environment '$venv_name' created and activated!"
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
