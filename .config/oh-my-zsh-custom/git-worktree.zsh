# Git worktree helper functions

# Create a new worktree and branch with the same name
function gwt_new {
  local project_name=$(git rev-parse --show-toplevel)
  local sanitized_branch=${1//[\/]/_}
  git worktree add -b "$1" ../${project_name}/${sanitized_branch} && git submodule update --init --recursive
}

# Create a worktree for an existing branch
function gwt_add {
  local project_name=$(git rev-parse --show-toplevel)
  local sanitized_branch=${1//[\/]/_}
  git worktree add ../${project_name}/${sanitized_branch} "$1" && git submodule update --init --recursive
}

# Completion for gwt - show existing branches (local and remote)
function _gwt() {
  branches=$(git branch --format='%(refname:short)' | sort -u)
  _describe 'branches' branches
}

compdef _gwt gwt
