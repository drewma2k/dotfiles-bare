---
name: home-bare-repo
description: >-
  Use whenever the user wants to track, commit, inspect, or change dotfiles under
  $HOME - "track this in dotfiles", "the bare repo", "commit my dotfiles", or any
  edit to ~/.zshrc, ~/.zprofile, ~/.zshenv, ~/.tmux.conf, ~/.vimrc, ~/.gitconfig,
  ~/.config/fish/, ~/.config/ghostty/, ~/.config/ranger/, ~/.config/oh-my-zsh-custom/,
  ~/bin/, or ~/.claude/. Covers the git mechanics; pair with update-local-setup for
  the track-it/log-it discipline.
---

# Home bare repo

The user version-controls files **in place** under `$HOME` with a bare git repo.
There are TWO distinct dotfile repos — don't confuse them.

## The two repos

1. **`~/.dotfiles` — the ACTIVE bare repo.** git-dir `~/.dotfiles`, work-tree `$HOME`,
   branch `main`, remote `https://github.com/drewma2k/dotfiles-bare.git`. Tracks files
   where they live: `~/.zshrc`, `~/.zprofile`, `~/.zshenv`, `~/.tmux.conf`, `~/.vimrc`,
   `~/.gitconfig`, `~/.config/fish/...`, `~/.claude/CLAUDE.md`,
   `~/.claude/skills/<name>/...`, `~/bin/...`, etc. `~/.gitignore` ignores `.claude/*`
   by default and re-includes an explicit allowlist — read it before adding a new
   tracked path under `~/.claude/`.

2. **`~/src/dotfiles` — LEGACY, not used for new work.** A regular clone with a
   `make install` symlink pattern (`configs/zshrc` → `~/.zshrc`, and likewise vimrc,
   tmux.conf, ranger rc.conf, ghostty config, oh-my-zsh custom). Superseded by the
   in-place bare repo. **Nothing symlinks into it anymore** — every path it would
   install is now a real file tracked by the bare repo. Everything goes through the
   bare repo; don't re-symlink into legacy, and never run its `make install`, which
   would clobber tracked files with `ln -si`.

## How the bare repo is driven (`git.fish`, not `config`)

The mechanism is a **directory-aware `git` wrapper** at
`~/.config/fish/functions/git.fish`. When you run `git` while standing under `$HOME`
but **not inside any other git repo**, it transparently routes to the bare repo
(`git --git-dir=$HOME/.dotfiles --work-tree=$HOME ...`). Inside a real repo, outside
`$HOME`, or for `clone`/`init`, `git` behaves normally. So interactively the user just
runs plain `git add` / `git commit` / `git status` from `$HOME` and it Just Works on
dotfiles.

The old **`config` alias is deprecated** — don't reach for it. It survives only as an
escape hatch for driving dotfiles-git from *inside another repo* (where the wrapper
deliberately stays out of the way). It's also defined only in interactive shells
(`~/.config/fish/config.fish`), so it does not exist in the Bash tool's shell.

## How to run it from the Bash tool

**Default to the explicit form** — it's cwd-independent and unambiguous:

```
git --git-dir=$HOME/.dotfiles --work-tree=$HOME <subcommand>
```

Why not rely on the wrapper: the Bash tool's working directory is usually *inside
another repo* (e.g. `~/src/dotfiles` or a project checkout), where plain `git`
correctly targets that repo, not dotfiles. The wrapper routes a plain `git` correctly
**only** when the cwd is under `$HOME` and outside any repo — so the explicit form is
the safe default unless you've deliberately `cd`'d somewhere under `$HOME` first.

Pass `--git-dir` and `--work-tree` as **separate arguments** — fish does not word-split
a single variable holding both flags, so `set gd "--git-dir=… --work-tree=…"; git $gd …`
fails with "not a git repository".

Examples:
- inspect: `git --git-dir=$HOME/.dotfiles --work-tree=$HOME status`
- history: `git --git-dir=$HOME/.dotfiles --work-tree=$HOME log --oneline -10`
- stage:   `git --git-dir=$HOME/.dotfiles --work-tree=$HOME add .tmux.conf`

`status` hides untracked by default (the work-tree is all of `$HOME`, so untracked
would be enormous noise) — the repo is configured `showUntrackedFiles=no`.
Consequently **new files won't appear in `status` and must be `git add`-ed by explicit
path** — don't assume an un-added new file is being ignored. Pass `-u` only when the
user asks to see untracked files.

## Disambiguation rules

- "track this in dotfiles" / "the bare repo" / anything under `~/.claude/`, `~/.zshrc`,
  `~/.config/fish/`, `~/.tmux.conf` → `~/.dotfiles`.
- A `config <anything>` invocation (deprecated muscle memory) → still means
  `~/.dotfiles`; run the explicit `git --git-dir=… --work-tree=…` equivalent.
- A new skill the user wants tracked goes under `~/.claude/skills/`, **not**
  `~/src/dotfiles/claude/skills/`.
- If both repos could apply, ask once which one.

## Adding a new tracked path under `~/.claude/`

`~/.gitignore` ignores `.claude/*` by default, so `git add` won't pick up a new path
until it's whitelisted. **Add the `!`-allowlist line to `~/.gitignore` first, then add
the files.**

Currently whitelisted: `CLAUDE.md`, `settings.json`, `settings.local.json`,
`keybindings.json`, `statusline-command.sh`, `skills/` (minus each skill's `.venv/` and
minus `skills/*/references/environment.md`, a per-host inventory kept local), and
`rules/`. Not yet tracked: `hooks/`, `docs/` — add `!.claude/hooks/` /
`!.claude/docs/` first if the user wants those tracked.

Note `rules/` is allowlisted but `~/.claude/rules/` does not exist yet on this host —
the line is inert until rules are created.

Writing to `~/.claude/settings.json` (especially adding `hooks`) may be refused by the
permission classifier even though the file is tracked. If that happens, hand the user
the exact JSON to paste rather than routing around the block.

## Logging changes for upstream

`~/UPSTREAM.md` is tracked by this repo but its format and rules live in the
**upstream-log** skill — use that for writing, reading, or applying entries.

## Common mistakes to avoid

- Reaching for the deprecated `config` alias — use plain `git` interactively, or the
  explicit `--git-dir`/`--work-tree` form from the Bash tool.
- Assuming plain `git` from the Bash tool hits the bare repo — it only routes when cwd
  is under `$HOME` outside a repo; otherwise it targets whatever repo you're in.
- Combining `--git-dir` and `--work-tree` into one shell variable (fish won't split
  it) — pass them as separate args.
- Trying `~/.cfg` — that path doesn't exist here.
- `git -C $HOME …` — `$HOME` has no `.git`, so this fails; use the git-dir form.
- Treating `~/.dotfiles` and `~/src/dotfiles` as the same history — they track
  different file sets and diverge independently.
- Running `make install` in `~/src/dotfiles` — it would symlink over real tracked files.
