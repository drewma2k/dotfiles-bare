#!/bin/sh
# Minimal Claude Code status line, styled after the docs example
# (https://code.claude.com/docs/en/statusline): "[Model] dir | seg | seg".
# No emojis, one subtle color. Receives Claude Code JSON on stdin.

input=$(cat)

dir=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // empty')
model=$(printf '%s' "$input" | jq -r '.model.display_name // empty')
ctx_used=$(printf '%s' "$input" | jq -r '.context_window.total_input_tokens // empty')
ctx_size=$(printf '%s' "$input" | jq -r '.context_window.context_window_size // empty')
session_pct=$(printf '%s' "$input" | jq -r '(.rate_limits.five_hour.used_percentage // empty) | if . == "" then empty else (. | round) end')

# Humanize a token count: 78838 -> 79k, 1000000 -> 1M (rounded).
hum() {
  n=$1
  if [ "$n" -ge 1000000 ]; then
    printf '%dM' $(( (n + 500000) / 1000000 ))
  elif [ "$n" -ge 1000 ]; then
    printf '%dk' $(( (n + 500) / 1000 ))
  else
    printf '%d' "$n"
  fi
}

# Nerd Font glyphs (monochrome, not emoji), built from UTF-8 bytes so they
# survive editing:  folder = U+F07B,  branch = U+E0A0 (powerline).
FOLDER=$(printf '\357\201\273')
BRANCH_ICON=$(printf '\356\202\240')

out="[${model}] ${FOLDER} ${dir##*/}"

[ -n "$ctx_used" ] && [ -n "$ctx_size" ] && out="$out | ctx $(hum "$ctx_used")/$(hum "$ctx_size")"
[ -n "$session_pct" ] && out="$out | ses ${session_pct}%"

if git -C "$dir" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$dir" symbolic-ref --short HEAD 2>/dev/null || git -C "$dir" rev-parse --short HEAD 2>/dev/null)
  [ -n "$branch" ] && out="$out | ${BRANCH_ICON} $branch"
fi

# One subtle color for the whole line.
printf '\033[2m%s\033[0m' "$out"
