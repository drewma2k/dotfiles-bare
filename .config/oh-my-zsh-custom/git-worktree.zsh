# Git worktree helper functions
#
# Mirrors the fish-side gwtx/gwta helpers: worktrees live in sibling
# directories named "<repo>.<branch>", we cd into the new tree, and init
# submodules. Branch names with '/' are sanitized to '.' for the path.

# Resolve the repo's top-level directory from the common git dir, so this
# works from inside a linked worktree as well as the main checkout.
function _gwt_project_root {
  local common_dir
  common_dir=$(git rev-parse --git-common-dir 2>/dev/null) || return 1
  ( cd "${common_dir}/.." && pwd -P )
}

# Build the sibling worktree path "<repo>.<sanitized-branch>".
function _gwt_dest {
  local project_root=$1 branch=$2
  print -r -- "${project_root:h}/${project_root:t}.${branch//\//.}"
}

# Create a new worktree and branch with the same name: gwtn <branch>
function gwtn {
  if [[ -z "$1" ]]; then
    print -u2 "usage: gwtn <branch>"
    return 1
  fi
  local project_root dest
  project_root=$(_gwt_project_root) || { print -u2 "gwtn: not in a git repo"; return 1; }
  dest=$(_gwt_dest "$project_root" "$1")
  git worktree add -b "$1" "$dest" \
    && cd "$dest" \
    && git submodule update --init --recursive
}

# Create a worktree for an existing branch: gwtx <branch>
function gwtx {
  if [[ -z "$1" ]]; then
    print -u2 "usage: gwtx <branch>"
    return 1
  fi
  local project_root dest
  project_root=$(_gwt_project_root) || { print -u2 "gwtx: not in a git repo"; return 1; }
  dest=$(_gwt_dest "$project_root" "$1")
  git worktree add "$dest" "$1" \
    && cd "$dest" \
    && git submodule update --init --recursive
}

# Completion - show existing branches (local and remote, deduped)
function _gwt_branches {
  local -a branches
  branches=(${(f)"$(git branch -a --format='%(refname:short)' | sed 's#^remotes/origin/##' | sort -u)"})
  _describe 'branches' branches
}

compdef _gwt_branches gwtn
compdef _gwt_branches gwtx
