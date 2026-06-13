# dotfiles

My dotfiles, managed as a **bare git repository** whose work-tree is `$HOME`.
No symlinks, no extra tooling — the tracked files *are* the real files in my home
directory.

> This README lives at `.github/README.md` (i.e. `~/.github/README.md`) so it
> renders on the GitHub repo page without putting a `README.md` in the root of
> `$HOME`.

## How it works

A bare repo lives at `~/.dotfiles` with its git-dir there and its work-tree set
to `$HOME`. A `config` shell function wraps git with those two flags so every
command operates on the dotfiles without affecting any other repo:

```fish
function config --description 'Manage $HOME dotfiles via bare repo'
    git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $argv
end
```

`status.showUntrackedFiles` is set to `no` so `config status` doesn't list the
entire home directory as untracked.

## Daily usage

Run `config` commands from `$HOME` (paths in `ls-files`/`status` are relative to
the current directory).

```fish
config status                 # what changed
config add ~/.zshrc           # stage a changed dotfile
config commit -m "tweak zshrc"
config push
config ls-files               # list everything tracked (run from ~)
```

Edit dotfiles directly in place (e.g. `nvim ~/.zshrc`) — there's no source/target
indirection.

## oh-my-zsh customs

The oh-my-zsh custom files live in `~/.config/oh-my-zsh-custom/` rather than the
default `~/.oh-my-zsh/custom/`. That default sits inside the oh-my-zsh git clone,
and a bare repo can't track files nested inside another repo's work-tree. `.zshrc`
sets `ZSH_CUSTOM` to point at the tracked location, so oh-my-zsh still loads them.

## Bootstrapping a new machine

```fish
git clone --bare https://github.com/drewma2k/dotfiles-bare.git $HOME/.dotfiles

# checkout into $HOME (may warn about pre-existing files; back them up or use -f)
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout

# don't show every home-dir file as untracked
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no
```

Opening a new shell (or sourcing `~/.config/fish/config.fish`) then provides the
`config` function for ongoing use.
