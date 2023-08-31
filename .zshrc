# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

RPROMPT='%D{%T} '$RPROMPT # 24h format
# RPROMPT='[%D{%L:%M:%S}] '$RPROMPT # 12h format

# ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_THEME="console"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
DISABLE_AUTO_UPDATE="false"

# Uncomment to change how often before auto-updates occur? (in days)
export UPDATE_ZSH_DAYS=7

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check much faster
# ZSH_DISABLE_COMPFIX=true
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment following line if you want to  shown in the command execution time stamp
# in the history command output. The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|
# yyyy-mm-dd
# HIST_STAMPS="mm/dd/yyyy"

# READNULLCMD is used whenever you have a null command reading input from a single file.
export READNULLCMD=less

export GPG_TTY=$(tty)

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=()

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
export EDITOR='vim'
export TERM=xterm-256color

# key bindings
bindkey "^P" up-line-or-search
bindkey "^N" down-line-or-search

# ALIASES
alias ls='ls -GFhl'
alias v='nvim'
alias vim='nvim'

# git
alias gs='git status '
alias ga='git add .'
alias gb='git branch '
alias gc='git commit -m'
alias gd='git diff'
alias go='git checkout '
alias gl='git lg'

alias be='bundle exec'
alias bs='browser-sync start --server --directory --files "*"'

alias tmux="TERM=screen-256color-bce tmux -2"

alias dash="docker exec -it application bash"
alias server="docker attach application"

alias dockup="docker compose up dev_app"
alias dockdn="docker compose down"
alias bp-dump="docker exec mysql /usr/bin/mysqldump -u root --password=root boardpackager4_development > ~/backup/db/dumps/bp-wip-mysql.dump"
alias bp-restore="cat ~/backup/db/dumps/bp-wip-mysql.dump | docker exec -i mysql /usr/bin/mysql -u root --password=root boardpackager4_development"
alias dcr="docker compose run"

alias deploy-dev="eb use BP-Dev --profile=bopa; eb deploy BP-Dev --profile=bopa;"
alias deploy-tst="eb use BP-Test --profile=bopa; eb deploy BP-Test --profile=bopa;"
alias deploy-tst2="eb use BP-Test2 --profile=bopa; eb deploy BP-Test2 --profile=bopa;"
alias deploy-stg="eb use BP-STG --profile=bopa; eb deploy BP-STG --profile=bopa"
alias deploy-prd="eb use BP-PRD --profile=bopa; eb deploy BP-PRD --profile=bopa;"

alias 'airport=/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I'
# alias 'ctags=/usr/local/bin/ctags'

# PATH
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export PATH="$HOME/.pyenv/versions/3.7.2/bin:$PATH"
export PATH="$HOME/.ebcli-virtual-env/executables:$PATH"
export PATH="$HOME/code/bp-tools/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:/usr/local/go/bin"
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
