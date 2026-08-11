# Upstream candidates

Running log of local dotfiles changes that may be worth porting to the upstream remote
(drewma2k/dotfiles-bare). Newest entries are appended at the bottom.

## 2026-08-11 - update-local-setup: per-host inventory, kept untracked

**Summary:** The update-local-setup skill ended with a placeholder comment saying its
`references/environment.md` inventory was omitted and should be rewritten per host.
Wrote that file for this machine, then made the "rewrite per host" part structural
instead of advisory: `~/.gitignore` now re-ignores
`.claude/skills/*/references/environment.md` beneath the `!.claude/skills/`
allowlist, so a skill's environment inventory can never be committed or ported by
accident. The skill's own workflow calls this out as the one file exempt from its
track-it (step 4) and log-it (step 5) rules, and home-bare-repo's whitelist summary
notes the new exclusion. Portable as-is; the inventory each host writes behind that
ignore rule is not.

```diff
--- a/.gitignore
+++ b/.gitignore
@@ -13,4 +13,7 @@
 !.claude/statusline-command.sh
 !.claude/skills/
 .claude/skills/*/.venv/
+# Per-host inventories: a skill's references/environment.md describes THIS machine
+# (paths, settings values, which dirs exist). Written fresh per host, never ported.
+.claude/skills/*/references/environment.md
 !.claude/rules/
--- a/.claude/skills/update-local-setup/SKILL.md
+++ b/.claude/skills/update-local-setup/SKILL.md
@@ -30,4 +30,14 @@
 6. Consistency sweep: re-read rules/docs/skills that reference what you touched;
    update anything now inaccurate - including the skill's own environment inventory.
 
-# (references/environment.md - a machine-specific inventory - omitted; rewrite per host)
+## This host
+
+`references/environment.md` is the machine-specific inventory: which mechanism owns
+what, where each tracked source of truth lives, what the gitignore allowlist currently
+covers, and what does *not* exist here. Read it at step 1, and update it at step 6
+whenever you change the shape of the setup.
+
+It is host-local and **untracked on purpose** (`~/.gitignore` excludes
+`.claude/skills/*/references/environment.md`), so it is the one file this skill's own
+workflow exempts from steps 4 and 5 — don't try to commit it or log it upstream.
+Write it fresh on each host rather than porting one machine's copy to another.
--- a/.claude/skills/home-bare-repo/SKILL.md
+++ b/.claude/skills/home-bare-repo/SKILL.md
@@ -93,8 +93,9 @@
 Currently whitelisted: `CLAUDE.md`, `settings.json`, `settings.local.json`,
-`keybindings.json`, `statusline-command.sh`, `skills/` (minus each skill's `.venv/`),
-and `rules/`. Not yet tracked: `hooks/`, `docs/` — add `!.claude/hooks/` /
+`keybindings.json`, `statusline-command.sh`, `skills/` (minus each skill's `.venv/` and
+minus `skills/*/references/environment.md`, a per-host inventory kept local), and
+`rules/`. Not yet tracked: `hooks/`, `docs/` — add `!.claude/hooks/` /
 `!.claude/docs/` first if the user wants those tracked.
```
