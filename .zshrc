# Enable Zsh's extended globbing and null_glob options
setopt extended_glob null_glob

# Set to superior editing mode
set -o vi

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

source ~/.aliases

# get rid of mail notifications on MacOS
unset MAILCHECK

# Preferred editor for local and remote sessions
export VISUAL=nvim
export EDITOR=nvim
export TERM="tmux-256color"

# key bindings
bindkey "^P" up-line-or-search
bindkey "^N" down-line-or-search

# History
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt HIST_IGNORE_SPACE  # Don't save when prefixed with space
setopt HIST_IGNORE_DUPS   # Don't save duplicate lines
setopt SHARE_HISTORY      # Share history between sessions

# Prompt
PURE_GIT_PULL=0

if [[ "$OSTYPE" == darwin* ]]; then
  fpath+=("$(brew --prefix)/share/zsh/site-functions")
else
  fpath+=($HOME/.zsh/pure)
fi

autoload -U promptinit; promptinit
prompt pure

# PATH
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export PATH="$HOME/.pyenv/versions/3.7.2/bin:$PATH"
export PATH="$HOME/.ebcli-virtual-env/executables:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:/usr/local/go/bin"

