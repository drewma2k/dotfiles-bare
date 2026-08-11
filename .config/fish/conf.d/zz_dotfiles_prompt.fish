# Make the pure fish prompt show ~/.dotfiles bare-repo status when standing under
# $HOME outside any real git repo - the prompt counterpart to functions/git.fish.
#
# Pure's git functions call `command git` (bypassing the git wrapper) and only show
# the git segment inside a discoverable repo, so nothing appears in dotfiles-tracked
# dirs. Here we override pure's `_pure_prompt_git`: when in dotfiles territory we set
# GIT_DIR/GIT_WORK_TREE as EXPORTED LOCALS and render *within that same scope*, so
# pure's `command git` subprocesses resolve against the bare repo. The vars are
# block-scoped and never leak to your interactive commands (verified). Real repos and
# paths outside $HOME are left untouched.
#
# Lives in conf.d (not pure's functions/ file) and is named zz_* to load last, so it
# survives `fisher update`.
function _pure_prompt_git --description 'pure git segment, ~/.dotfiles bare-repo aware'
    set ABORT_FEATURE 2

    if set --query pure_enable_git; and test "$pure_enable_git" != true
        return
    end

    if not type -q --no-functions git # skip when git is unavailable
        return $ABORT_FEATURE
    end

    if command git rev-parse --is-inside-work-tree >/dev/null 2>&1
        # Inside a real repo (or ambient GIT_DIR): render normally.
        __dotfiles_git_segment
    else
        # Not in a repo: if under $HOME, render against the bare repo for this render only.
        switch (pwd -P)
            case "$HOME" "$HOME/*"
                set --local --export GIT_DIR "$HOME/.dotfiles"
                set --local --export GIT_WORK_TREE "$HOME"
                __dotfiles_git_segment
        end
    end
end

# Pure's original branch/dirty/stash/pending rendering, factored out so it can run
# inside the bare-repo GIT_DIR scope above. Mirrors upstream _pure_prompt_git's body.
function __dotfiles_git_segment --description 'render pure git segment for the active repo'
    set --local is_git_repository (command git rev-parse --is-inside-work-tree 2>/dev/null)
    test -n "$is_git_repository"; or return

    set --local git_prompt (_pure_prompt_git_branch)(_pure_prompt_git_dirty)(_pure_prompt_git_stash)
    set --local git_pending_commits (_pure_prompt_git_pending_commits)

    if test (_pure_string_width $git_pending_commits) -ne 0
        set --append git_prompt $git_pending_commits
    end

    echo $git_prompt
end
