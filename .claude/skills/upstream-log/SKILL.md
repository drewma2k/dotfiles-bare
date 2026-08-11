---
name: upstream-log
description: >-
  Use for anything involving ~/UPSTREAM.md - the running log of dotfiles changes
  worth porting to the upstream remote. Triggers on "log this for upstream", "add an
  upstream entry", "what's in the upstream log", "port these changes", or reviewing
  and applying entries that were written elsewhere. Pair with home-bare-repo for the
  git mechanics of committing what you log.
---

# Upstream log (`~/UPSTREAM.md`)

`~/UPSTREAM.md` is a running log of local dotfiles changes worth porting to the
upstream remote (`drewma2k/dotfiles-bare`). It lives at `$HOME`, outside the
`.claude/*` ignore rule, and is tracked by the `~/.dotfiles` bare repo.

## Entry format

Entries are appended at the **bottom** (newest last). Each has three parts:

1. Heading: `## YYYY-MM-DD - <short title>`
2. `**Summary:**` — one short paragraph on what changed and why
3. A fenced ` ```diff ` block scoped to that change

Match the existing entries' format. Convert relative dates to absolute. Keep the diff
scoped to the one change the entry describes — not the whole working tree.

## Writing an entry

Nothing enforces the log, so it's easy to forget. When the user asks to log a change,
or when you commit dotfiles and the change is one another machine would plausibly
want, append an entry.

An entry is worth writing when the change is **portable** — a mechanism, a config
pattern, a fix others would hit. Skip host-local noise: absolute paths tied to one
machine, credentials, per-host inventories.

## Applying an entry

Entries may have been written on a different host. **They are not automatically
applicable here — verify every claim against this machine before applying one.**
Plugin names, absolute paths, usernames, sandbox restrictions, and managed policy
all differ between hosts, and a faithfully-mirrored entry can actively break things.

Check specifically:

- **Referenced helper functions actually exist here.** e.g. the fish git plugin on this
  host is `jhillyerd/plugin-git`, providing `__git.current_branch`; `git_current_branch`
  does not exist. An entry rewriting `gpsup` to use it would break the abbreviation.
- **Absolute paths and usernames resolve.** Home paths and hook script paths from
  another host will not exist here.
- **Sandbox and policy claims hold.** The Bash tool *can* `mkdir`/`touch`/`rm` under
  `~/.claude/skills/` here, and no managed policy restricts hooks — so user-defined
  hooks work, and an entry's workaround for not having them is unnecessary here.
- **The files being patched exist.** An entry may be a hunk against a file this host
  doesn't have; a partial diff cannot be reconstructed into a whole file.

When an entry doesn't apply, say so and why rather than forcing it. When only part
applies, take the portable part and state what you dropped.

## Reading the log

The log is append-only history, not current state. A later entry may supersede an
earlier one — read forward before concluding what the current intent is.
