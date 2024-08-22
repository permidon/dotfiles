# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Set to superior editing mode
set -o vi

# keybinds
bind -x '"\C-l":clear'

# get rid of mail notifications on MacOS
unset MAILCHECK

# Environment Variables
# export HISTFILE=~/.histfile
export HISTSIZE=25000
export SAVEHIST=25000
export HISTCONTROL=ignorespace
export VISUAL=nvim
export EDITOR=nvim
export TERM="tmux-256color"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# PATH
export PATH="$HOME/.ebcli-virtual-env/executables:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export XDG_CONFIG_HOME="$HOME"/.config
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

source "$HOME/.aliases"

# Determine git branch name
function parse_git_branch {
  git branch 2> /dev/null | sed -n 's/^\* //p'
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
      PS1="\[\e[0;36m\]\W\[\e[m\]\[\e[0;37m\] [${branch_color_dirty}${branch}\[\e[0;37m\]]\[\e[m\] » "
    else
      PS1="\[\e[0;36m\]\W\[\e[m\]\[\e[0;37m\] [${branch_color_clean}${branch}\[\e[0;37m\]]\[\e[m\] » "
    fi
  else
    PS1="\[\e[0;36m\]\W\[\e[m\] » "
  fi
}

# Specify the color for the branch name
branch_color_clean="\[\e[0;32m\]" # Green
# branch_color_clean="\[\e[0;37m\]" # White
branch_color_dirty="\[\e[0;31m\]"  # Red

PROMPT_COMMAND=set_git_prompt

export PS1

