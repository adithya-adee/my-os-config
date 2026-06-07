export PATH="$HOME/.local/bin:$PATH"
export ZSH="$HOME/.oh-my-zsh"
fpath+=($HOME/.zsh/pure)

# Initialize Pure
autoload -U promptinit; promptinit
prompt pure

zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# DISABLE_MAGIC_FUNCTIONS="true"
# DISABLE_LS_COLORS="true"
# DISABLE_AUTO_TITLE="true"
# ENABLE_CORRECTION="true" # Comment the following line to disable command auto-correction 

COMPLETION_WAITING_DOTS="true"

ZSH_CUSTOM="$ZSH/custom"
plugins=(git postgres docker zsh-autosuggestions zsh-syntax-highlighting fzf-tab) 

source $ZSH/oh-my-zsh.sh

# PNPM
alias pnlg="pnpm list -g"
alias pnst="pnpm store"

# vim
alias pvi="NVIM_APPNAME=pure-nvim nvim"
alias lvim="NVIM_APPNAME=nvim-lazyvim nvim"
alias editlvim="vipro ~/.config/nvim-lazyvim/"
alias editvipro="vipro ~/.config/nvim-pro/"
alias editpvi="vipro ~/.config/pure-nvim/"

# zsh alias
alias zs="nvim ~/.zshrc"
alias src="source ~/.zshrc"
alias ks="nvim ~/.config/kitty/kitty.conf"

# navigation
alias .="cd .."
alias ..="cd ../.."

# ls to lsd
alias ls="eza --icons --group-directories-first"
alias la="eza -a --icons --group-directories-first"
alias ll="eza -l --icons --group-directories-first"
alias lt="eza --tree --icons"

# common
alias cls="clear"
alias x="exit"
alias ag="alias | grep"
alias rs="rustc"
alias bat="batcat"

# du command
alias duall="du -hs .[^.]*"

# git commands
alias gcg="git config --edit --global"
alias gcl="git config --edit --local"
alias gc="git clone"
alias gout="git checkout"
alias gs="git status"
alias gl="git log"
alias gcom="git commit -m"
alias gd="git diff"
alias gld="git log --graph --oneline"
alias glg="git log --pretty=format:"%h %s" --graph"

# jupyter lab
alias jupy="source ~/glitchy_moon/jupyter/bin/activate"
alias jl="jupyter lab"
alias jn="jupyter notebook"

# display
alias nf="neofetch"
alias ff="fastfetch"

alias randi="npm run dev"

# boot command
alias sdn="shutdown now"
alias rbt="reboot"

# commands executed at the start of terminal
ff

export EDITOR=vim
export VISUAL=vim
export PATH="/opt/nvim:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# bun completions
[ -s "/home/glitchy_moon/.bun/_bun" ] && source "/home/glitchy_moon/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# poetry
fpath+=~/.zfunc
autoload -Uz compinit && compinit


# pnpm
export PNPM_HOME="/home/glitchy_moon/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end
#
# Solana
export PATH="/home/glitchy_moon/solana-1.18.18/bin:$PATH"

# Cargo
export PATH="$HOME/.cargo/bin:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/glitchy_moon/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/glitchy_moon/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/home/glitchy_moon/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/home/glitchy_moon/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba shell init' !!
export MAMBA_EXE='/home/glitchy_moon/miniforge3/bin/mamba';
export MAMBA_ROOT_PREFIX='/home/glitchy_moon/miniforge3';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias mamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<

# hudl
export PATH="/home/glitchy_moon/.hudl:$PATH"

export GEMINI_MODEL="gemini-2.5-pro"

# opencode
export PATH=/home/glitchy_moon/.opencode/bin:$PATH

# Genymotion
export PATH="$PATH:/home/glitchy_moon/genymotion"

# Claude Code exports
export COLOSSEUM_COPILOT_API_BASE="https://copilot.colosseum.com/api/v1"
export COLOSSEUM_COPILOT_PAT="FILL_IN"

export CLAUDE_CODE_USE_OPENAI=1
export OPENAI_BASE_URL="http://127.0.0.1:11434/v1"
export OPENAI_MODEL=qwen2.5-coder:7b

# Android Studio and SDK Environment Variables
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/emulator
alias vi="NVIM_APPNAME=nvim-lazyvim nvim"

# Productivity improvements
bindkey "^ " autosuggest-accept
eval "$(zoxide init zsh)"

# fzf configuration
source /usr/share/doc/fzf/examples/completion.zsh
source /usr/share/doc/fzf/examples/key-bindings.zsh

# fzf-tab configuration
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:*:*' fzf-preview 'batcat --color=always --style=numbers $realpath 2>/dev/null || eza -1 --color=always $realpath'
alias m2p="md2pdf"
alias m2ps="md2pdf -s"

# LaTeX
t2p() { xelatex -interaction=nonstopmode "$1" && xelatex -interaction=nonstopmode "$1" }
alias rgrep="rg"
