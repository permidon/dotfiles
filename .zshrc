# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load. Default theme is "robbyrussell"
ZSH_THEME="minimal"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check much faster
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(iterm2 git ruby rails)

source $ZSH/oh-my-zsh.sh

# Aliases
alias ls='ls -GFhl'

alias gs='git status '
alias ga='git add .'
alias gb='git branch '
alias gc='git commit -m'
alias gd='git diff'
alias go='git checkout '
alias gl='git lg'

alias r='rails'
alias rc='rails c'
alias rs='rails server'
alias rg='rails generate'
alias rr='rails routes'

alias be='bundle exec'
alias bs='browser-sync start --server --directory --files "*"'

alias tmux="TERM=screen-256color-bce tmux -2"

# PATHS
export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH="/usr/local/opt/openssl/bin:$PATH"
export PATH="$(brew --prefix qt@5.5)/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"

# Custom configuration
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
