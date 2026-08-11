# Auto-route `git` to the ~/.dotfiles bare repo when standing anywhere under
# $HOME that is NOT inside a normal git repository. Inside a real repo, or
# outside $HOME, `git` behaves exactly as usual.
#
# Rationale: the dotfiles bare repo has git-dir ~/.dotfiles and work-tree $HOME,
# so plain `git` in $HOME would otherwise find no repo. This makes `git status`,
# `git add`, `git commit`, `git log`, etc. Just Work on dotfiles from $HOME while
# staying out of the way inside real project repos.
#
# Supersedes the old `config` alias (kept as an explicit escape hatch for running
# dotfiles git from *inside* another repo).
#
# Repo-creating commands (clone/init) are never rerouted, so they don't inherit
# the bare repo's --git-dir/--work-tree.
function git --wraps git --description 'Route to dotfiles bare repo when outside a repo under $HOME'
    # Never reroute commands that establish their own repo context.
    switch $argv[1]
        case clone init
            command git $argv
            return
    end

    # Inside a real git repo? Behave normally.
    if command git rev-parse --is-inside-work-tree >/dev/null 2>&1
        command git $argv
        return
    end

    # Not in a repo: if we're under $HOME, drive the dotfiles bare repo.
    switch (pwd -P)
        case "$HOME" "$HOME/*"
            command git --git-dir=$HOME/.dotfiles --work-tree=$HOME $argv
        case '*'
            command git $argv
    end
end
