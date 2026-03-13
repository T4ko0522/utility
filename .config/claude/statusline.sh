#!/usr/bin/env bash
# Claude Code statusline script
# Reads JSON from stdin and outputs formatted status bar

set -euo pipefail

# Read JSON from stdin
input=$(cat)

# Parse fields with jq
cwd=$(echo "$input" | jq -r '.cwd // ""' | tr '\\' '/')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
model=$(echo "$input" | jq -r '.model.display_name // "Unknown"')

# Get git branch (not included in JSON)
branch=""
if git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch=$(git -C "$cwd" branch --show-current 2>/dev/null || echo "")
fi

# Shorten home directory in path (handle Windows path variants)
win_home=$(cygpath -w "$HOME" 2>/dev/null || echo "")
short_cwd="$cwd"
if [ -n "$win_home" ]; then
  short_cwd="${short_cwd/#$win_home/\~}"
  short_cwd="${short_cwd/#${win_home//\\//}/\~}"
fi
short_cwd="${short_cwd/#$HOME/\~}"

# Color codes
RESET='\033[0m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
CYAN='\033[36m'
DIM='\033[2m'

# Context color based on usage percentage
if [ "$used_pct" -ge 90 ] 2>/dev/null; then
  ctx_color="$RED"
elif [ "$used_pct" -ge 70 ] 2>/dev/null; then
  ctx_color="$YELLOW"
else
  ctx_color="$GREEN"
fi

# Build line 1: branch + directory
line1=""
if [ -n "$branch" ]; then
  line1="${GREEN}🌿 ${branch}${RESET} ${DIM}|${RESET} "
fi
line1="${line1}${CYAN}📁 ${short_cwd}${RESET}"

# Build line 2: context + cost + model
cost_fmt=$(printf '$%.4f' "$cost")
line2="${ctx_color}Context: ${used_pct}%${RESET} ${DIM}|${RESET} ${cost_fmt} ${DIM}|${RESET} ${DIM}${model}${RESET}"

echo -e "$line1"
echo -e "$line2"
