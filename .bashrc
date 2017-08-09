# ~/.bashrc: executed by bash(1) for non-login shells.
export CLICOLOR=1
export LSCOLORS=ExfxcxdxbxexexaxgxCxDx

set CLICOLOR_FORCE yes
# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=-1
HISTFILESIZE=-1
HISTTIMEFORMAT="%F %T "

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt

bind '"\eOC":forward-word'
bind '"\e[1;5C":forward-word'
bind '"\eOD":backward-word'
bind '"\e[1;5D":backward-word'
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'
bind '"\eOA":history-search-backward'
bind '"\eOB":history-search-forward'
bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'
bind 'set completion-query-items 30'
bind 'set editing-mode emacs'

# some more ls aliases
alias ll='ls -ahlF'
alias la='ls -A'
alias ls='ls -GFhl'

alias gs='git status '
alias ga='git add '
alias gb='git branch '
alias gc='git commit'
alias gd='git diff'
alias go='git checkout '
alias gk='gitk --all&'
alias gx='gitx --all'

alias got='git '
alias get='git '

# get current status of git repo
function parse_git_dirty {
  new_status=`git status --porcelain`
  ahead=`git status -sb 2> /dev/null | grep -o "ahead [0-9]*" | grep -o "[0-9]*"`
  behind=`git status -sb 2> /dev/null | grep -o "behind [0-9]*" | grep -o "[0-9]*"`
  # staged files
  X=`echo -n "${new_status}" 2> /dev/null | cut -c 1-1`
  # unstaged files
  Y=`echo -n "${new_status}" 2> /dev/null | cut -c 2-2`
  modified_unstaged=`echo -n "${Y}" | grep "M" -c`
  deleted_unstaged=`echo -n "${Y}" | grep "D" -c`
  untracked_unstaged=`echo -n "${Y}" | grep "?" -c`
  modified_staged=`echo -n "${X}" | grep "M" -c`
  deleted_staged=`echo -n "${X}" | grep "D" -c`
  renamed_staged=`echo -n "${X}" | grep "R" -c`
  new_staged=`echo -n "${X}" | grep "A" -c`
  # unstaged_files
  if [ "${modified_unstaged}" != "0" ]; then
    unstaged_files="%${modified_unstaged}${unstaged_files}"
  fi
  if [ "${deleted_unstaged}" != "0" ]; then
    unstaged_files="-${deleted_unstaged}${unstaged_files}"
  fi
  if [ "${untracked_unstaged}" != "0" ]; then
    unstaged_files="*${untracked_unstaged}${unstaged_files}"
  fi
  # staged_files
  if [ "${modified_staged}" != "0" ]; then
    staged_files="%${modified_staged}${staged_files}"
  fi
  if [ "${deleted_staged}" != "0" ]; then
    staged_files="-${deleted_staged}${staged_files}"
  fi
  if [ "${renamed_staged}" != "0" ]; then
    staged_files="^${renamed_staged}${staged_files}"
  fi
  if [ "${new_staged}" != "0" ]; then
    staged_files="+${new_staged}${staged_files}"
  fi
}

# determine git branch name
function parse_git_branch(){
  git branch 2> /dev/null | sed -n 's/^\* //p'
}

# Determine the branch/state information for this git repository.
function set_git_branch() {
  # Get the name of the branch.
  branch=$(parse_git_branch)
  BRANCH=''
  if [ ! "${branch}" == "" ]; then
    staged_files=''
    unstaged_files=''
    parse_git_dirty
    if [ ! "${staged_files}" == "" ]; then
      staged_files="|${GREEN}${staged_files}${NORMAL}"
    fi
    if [ ! "${unstaged_files}" == "" ]; then
      unstaged_files="|${YELLOW}${unstaged_files}${NORMAL}"
    fi
    if [ ! "${ahead}" == "" ]; then
      ahead="${LIGHT_GREEN}{>${ahead}}${NORMAL}"
    fi
    if [ ! "${behind}" == "" ]; then
      behind="${LIGHT_RED}{<${behind}}${NORMAL}"
    fi
    # Set the final branch string.
    BRANCH=" (${CYAN}${branch}${NORMAL}${ahead}${behind}${unstaged_files}${staged_files}) "
  fi

}

# Return the prompt symbol to use, colorized based on the return value of the
# previous command.
function set_prompt_symbol () {
  if test $1 -eq 0 ; then
    P_SYMBOL="${BLUE}\n➤${NORMAL} "
  else
    P_SYMBOL="${LIGHT_RED}[$1]\n➤${NORMAL} "
  fi
}

COLOR_RED="\033[0;31m"
COLOR_YELLOW="\033[0;33m"
COLOR_GREEN="\033[0;32m"
COLOR_OCHRE="\033[38;5;95m"
COLOR_BLUE="\033[0;34m"
COLOR_WHITE="\033[0;37m"
COLOR_RESET="\033[0m"

function git_color {
  local git_status="$(git status 2> /dev/null)"

  if [[ ! $git_status =~ "working directory clean" ]]; then
    echo -e $COLOR_GREEN
  elif [[ $git_status =~ "Your branch is ahead of" ]]; then
    echo -e $COLOR_YELLOW
  elif [[ $git_status =~ "nothing to commit" ]]; then
    echo -e $COLOR_GREEN
  else
    echo -e $COLOR_OCHRE
  fi
}

function git_branch () {
  local git_status="$(git status 2> /dev/null)"
  local on_branch="On branch ([^${IFS}]*)"
  local on_commit="HEAD detached at ([^${IFS}]*)"

  if [[ $git_status =~ $on_branch ]]; then
    local branch=${BASH_REMATCH[1]}
    echo "($branch)"
  elif [[ $git_status =~ $on_commit ]]; then
    local commit=${BASH_REMATCH[1]}
    echo "($commit)"
  fi
}

PS1='\[\e[0;32m\]\[\e[1;34m\]\W\[\e[m\] \[\e[1;32m\]»\[\e[m\] '
PS1+="\[\$(git_color)\]"        # colors git status
PS1+="\$(git_branch)"           # prints current branch

export PS1

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
