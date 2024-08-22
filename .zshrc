# Enable Zsh's extended globbing and null_glob options
setopt extended_glob null_glob

# Set to superior editing mode
set -o vi

# aliases
source "$HOME/.aliases"

# Environment Variables
export HISTSIZE=25000
export SAVEHIST=25000
export VISUAL=nvim
export EDITOR=nvim
export TERM="tmux-256color"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# PATH
export PATH="$HOME/.ebcli-virtual-env/executables:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export XDG_CONFIG_HOME="$HOME"/.config
# export PATH="$HOME/.rbenv/bin:$PATH"
# eval "$(rbenv init -)"

# get rid of mail notifications on MacOS
unset MAILCHECK

# Key bindings
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward

# History
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_SPACE  # Don't save when prefixed with space
setopt HIST_IGNORE_DUPS   # Don't save duplicate lines
setopt SHARE_HISTORY      # Share history between sessions

# Prompt
# Set the git prompt when the prompt is displayed
precmd_functions+=set_git_prompt

# Determine git branch name
function parse_git_branch {
  git symbolic-ref --short HEAD 2> /dev/null
}

# Determine git repository status
function is_git_dirty {
  [[ -n "$(git status --porcelain)" ]]
}

# Check if in a git repository and set the prompt accordingly
function set_git_prompt {
  branch=$(parse_git_branch)
  if [[ -n ${branch} ]]; then
    if is_git_dirty; then
      PROMPT="%F{cyan}%1~%f%F{white} [%F{red}${branch}%F{white}] » "
    else
      PROMPT="%F{cyan}%1~%f%F{white} [%F{green}${branch}%F{white}] » "
    fi
  else
    PROMPT="%F{cyan}%1~%f » "
  fi
}

# Set the git prompt when the prompt is displayed
precmd_functions+=(set_git_prompt)

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

