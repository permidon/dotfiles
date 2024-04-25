ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[white]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[white]%}]"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}"

PROMPT='%{$fg[cyan]%}%1~$(git_prompt_info) %{$reset_color%}» '

# Determine git branch name
function parse_git_branch {
  git branch 2> /dev/null | sed -n 's/^\* //p'
}

# Determine git repository status
function is_git_dirty {
  [[ -n "$(git status --porcelain)" ]]
}

# Get git repository information for prompt
function git_prompt_info {
  local branch=$(parse_git_branch)
  if [[ -n "$branch" ]]; then
    local branch_color
    if is_git_dirty; then
      branch_color="$ZSH_THEME_GIT_PROMPT_DIRTY"
    else
      branch_color="$ZSH_THEME_GIT_PROMPT_CLEAN"
    fi
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${branch_color}${branch}$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

# Set git prompt and command
function set_git_prompt {
  PS1="%{$fg[cyan]%}%1~$(git_prompt_info) %{$reset_color%}» "
}

PROMPT_COMMAND=set_git_prompt

