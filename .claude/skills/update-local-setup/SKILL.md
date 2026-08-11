---
name: update-local-setup
description: >-
  Use whenever you add, change, or remove ANY custom local configuration -
  Claude Code config (settings/rules/skills/hooks/statusline) or tracked dotfiles.
  Triggers on "add a setting", "make a new rule", "create a skill", "install a hook",
  "track this in dotfiles". Pair with skill-creator (skill craft) and the bare-repo
  skill (git mechanics).
  For any Claude Code SETTINGS change, this skill co-applies with the built-in
  update-config skill - using both is fine, but this skill's placement rule GOVERNS:
  edit the tracked settings source (~/.claude/settings.json on this host), then
  track and log the change.
---

# Update local setup

## The one rule that matters
> If you add or change custom configuration, you MUST track it, log it, and check
> whether any rule or skill now describes the world inaccurately.

## Workflow for any config change
1. Locate which mechanism owns the thing (setting / rule / skill / dotfile / hook).
2. Edit the *tracked source of truth*, not a live/generated file.
   The built-in update-config skill may also fire for settings tasks; it's fine to use
   both, but its edits belong in the tracked source, and the change still needs to be
   tracked and logged.
3. Ensure the path is trackable (allowlist it if the repo ignores it by default).
4. Track it in the dotfiles repo (defer git mechanics to the home-bare-repo skill).
5. Log it in the upstream log (defer format and rules to the upstream-log skill).
6. Consistency sweep: re-read rules/docs/skills that reference what you touched;
   update anything now inaccurate - including the skill's own environment inventory.

# (references/environment.md - a machine-specific inventory - omitted; rewrite per host)
