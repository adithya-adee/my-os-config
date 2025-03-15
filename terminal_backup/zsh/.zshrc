# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
fpath+=($HOME/.zsh/pure)

# Intialize Pure
autoload -U promptinit; promptinit
prompt pure

# bindkey
bindkey -e
# ZSH_THEME="eastwood"
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion CASE_SENSITIVE="true"

zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"
# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"
# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

ENABLE_CORRECTION="true" # Comment the following line to disable command auto-correction 
COMPLETION_WAITING_DOTS="true"

# Would you like to use another custom folder than $ZSH/custom? ZSH_CUSTOM=/path/to/new-custom-folder  
ZSH_CUSTOM={$ZSH}/plugins
# Add wisely, as too many plugins slow down shell startup.
plugins=(git postgres docker zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh
# export LANG=en_US.UTF-8

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.

# vim
alias vi="nvim"

# zsh alias
alias zs="nvim ~/.zshrc"
alias src="source ~/.zshrc"
alias ks="nvim ~/.config/kitty/kitty.conf"

# navigation
alias .="cd .."
alias ..="cd ../.."

# ls to lsd
alias ls="lsd"
alias la="lsd -a"
alias ll="lsd -l"
alias lt="lsd --tree"

# common
alias cls="clear"
alias x="exit"
alias ag="alias | grep"


# git commands
alias gcg="git config --edit --global"
alias gcl="git config --edit --local"
alias gc="git clone"
alias gout="git checkout"
alias gs="git status"
alias gl="git log"
alias gcom="git commit -m"
alias gd="git diff"

# display
alias nf="neofetch"
alias ff="fastfetch"

# boot command
alias sdn="shutdown now"
alias rbt="reboot"
# commands executed at the start of terminal
ff
