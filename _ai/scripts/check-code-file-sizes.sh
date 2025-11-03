#!/usr/bin/env bash
# check-code-file-sizes.sh
# Generic file-size linter for common source-code files.
# - Scans repo for common code extensions
# - Compares each file's size against per-extension thresholds
# - Reports violations; with --fix, moves offenders into _ai/memory/refactoring/
#
# Usage:
#   ./check-code-file-sizes.sh [--fix] [--root PATH] [--verbose]
#
# Exit codes:
#   0  OK (no violations)
#   1  Violations found
#   2  Misuse / unexpected error
#
# You can override defaults via environment:
#   DEFAULT_LIMIT_KB=64                       # fallback limit for unknown extensions
#   LIMIT_go=64 LIMIT_js=256 LIMIT_ts=256    # examples of per-extension overrides (in KiB)
#   LIMIT_md=512 LIMIT_png=0                 # 0 disables checking for that extension
#
# Notes:
# - Intended for CI; pair with --fix in local workflows to stage refactors.
# - Excludes common large/third-party folders by default.

set -euo pipefail

ROOT_DIR="$(pwd)"
FIX=0
VERBOSE=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --fix) FIX=1; shift ;;
    --root) ROOT_DIR="$2"; shift 2 ;;
    --verbose|-v) VERBOSE=1; shift ;;
    *) echo "Unknown arg: $1" >&2; exit 2 ;;
  esac
done

cd "$ROOT_DIR"

# Default per-extension limits (KiB). Tweak as needed.
# The goal is to catch suspiciously large source files that likely need refactoring.
declare -A LIMITS=(
  # Systems / backend
  [go]=64
  [rs]=96
  [c]=96
  [h]=96
  [cpp]=128
  [hpp]=128
  [cc]=128
  [cs]=192
  [java]=192
  [kt]=192
  [kts]=192
  [swift]=192
  [scala]=192
  [php]=192
  [rb]=128
  [py]=128
  [sh]=32
  [bash]=32
  [zsh]=32
  # Web
  [js]=256
  [jsx]=320
  [ts]=256
  [tsx]=320
  [vue]=256
  [svelte]=256
  [css]=192
  [scss]=256
  [sass]=256
  [html]=256
  [xml]=256
  [json]=192
  [yaml]=192
  [yml]=192
  [toml]=192
  [sql]=256
  [md]=512   # docs can be larger, but we still want a limit
)

DEFAULT_LIMIT_KB="${DEFAULT_LIMIT_KB:-128}"

# Allow env overrides like LIMIT_js=300
for k in "${!LIMITS[@]}"; do
  env_key="LIMIT_${k}"
  if [[ -n "${!env_key-}" ]]; then
    LIMITS[$k]="${!env_key}"
  fi
done

# Patterns to include (extensions) and default excludes
EXTS=(
  go rs c h cpp hpp cc cs java kt kts swift scala php rb py sh bash zsh
  js jsx ts tsx vue svelte css scss sass html xml json yaml yml toml sql md
)

EXCLUDES=(
  .git .hg .svn .idea .vscode
  node_modules vendor dist build out target coverage .next .nuxt .turbo .cache
  .venv venv __pycache__ .mypy_cache .pytest_cache
  bin obj gradle .gradle .terraform .direnv
  public static assets logs tmp
)

# Build find predicates
EXCLUDE_PRED=()
for d in "${EXCLUDES[@]}"; do
  EXCLUDE_PRED+=( -path "*/$d/*" -prune -o )
done

INCLUDE_PRED=( \( )
for i in "${!EXTS[@]}"; do
  ext="${EXTS[$i]}"
  INCLUDE_PRED+=( -name "*.${ext}" )
  if [[ $i -lt $(( ${#EXTS[@]} - 1 )) ]]; then
    INCLUDE_PRED+=( -o )
  fi
done
INCLUDE_PRED+=( \) -type f )

# Collect files
mapfile -t FILES < <(find . "${EXCLUDE_PRED[@]}" "${INCLUDE_PRED[@]}")

[[ $VERBOSE -eq 1 ]] && echo "Found ${#FILES[@]} files to check." >&2

violations=0
declare -a REPORT

bytes_to_kib () {
  # Round up division by 1024
  local bytes="$1"
  echo $(( (bytes + 1023) / 1024 ))
}

get_limit_for_ext () {
  local ext="$1"
  if [[ -n "${LIMITS[$ext]+x}" ]]; then
    echo "${LIMITS[$ext]}"
  else
    echo "$DEFAULT_LIMIT_KB"
  fi
}

for f in "${FILES[@]}"; do
  # extract extension, lowercased
  base="${f##*/}"
  ext="${base##*.}"
  ext="${ext,,}"

  # skip if limit is explicitly 0 (disabled)
  limit_kib="$(get_limit_for_ext "$ext")"
  if [[ "$limit_kib" -eq 0 ]]; then
    [[ $VERBOSE -eq 1 ]] && echo "Skipping $f (ext .$ext disabled)" >&2
    continue
  fi

  # file size in bytes (portable)
  if stat --version >/dev/null 2>&1; then
    # GNU stat
    bytes="$(stat -c %s "$f")"
  else
    # BSD/macOS
    bytes="$(stat -f %z "$f")"
  fi
  kib="$(bytes_to_kib "$bytes")"

  if (( kib > limit_kib )); then
    ((violations++))
    REPORT+=( "$(printf "%-8s %8s KiB > %-6s KiB  %s" ".$ext" "$kib" "$limit_kib" "$f")" )

    if [[ $FIX -eq 1 ]]; then
      dest_dir="_ai/memory/refactoring/${ext}"
      mkdir -p "$dest_dir"
      # preserve relative path structure under new root
      rel="${f#./}"
      mv "$f" "$dest_dir/$(basename "$rel")"
      echo "Moved $f -> $dest_dir/$(basename "$rel")"
    fi
  fi
done

if (( violations > 0 )); then
  echo "File size violations (${violations}):"
  printf "%s\n" "${REPORT[@]}"
  if [[ $FIX -eq 1 ]]; then
    echo
    echo "Offending files were moved to _ai/memory/refactoring/ by extension."
  else
    echo
    echo "Run again with --fix to move offending files under _ai/memory/refactoring/."
  fi
  exit 1
else
  echo "All checked files are within limits. Nice and tidy."
fi
