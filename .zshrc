# Enable Zsh's extended globbing and null_glob options
setopt extended_glob null_glob

# Set to superior editing mode
set -o vi

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

source ~/.aliases

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

RPROMPT='%D{%T} '$RPROMPT # 24h format
# RPROMPT='[%D{%L:%M:%S}] '$RPROMPT # 12h format

# ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_THEME="console"

# Uncomment this to disable bi-weekly auto-update checks
DISABLE_AUTO_UPDATE="false"

# Uncomment to change how often before auto-updates occur? (in days)
export UPDATE_ZSH_DAYS=7

# Uncomment following line if you want to disable autosetting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
DISABLE_CORRECTION="true"

# READNULLCMD is used whenever you have a null command reading input from a single file.
export READNULLCMD=less

export GPG_TTY=$(tty)

# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=()

source $ZSH/oh-my-zsh.sh

# get rid of mail notifications on MacOS
unset MAILCHECK

# Preferred editor for local and remote sessions
export VISUAL=nvim
export EDITOR=nvim
export TERM=xterm-256color

# key bindings
bindkey "^P" up-line-or-search
bindkey "^N" down-line-or-search

# PATH
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export PATH="$HOME/.pyenv/versions/3.7.2/bin:$PATH"
export PATH="$HOME/.ebcli-virtual-env/executables:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:/usr/local/go/bin"

if [[ "$OSTYPE" == "darwin"* ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
