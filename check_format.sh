#!/usr/bin/env bash

set -euo pipefail

has_errors=0

while IFS= read -r -d '' file; do
  base_name="$(basename "$file")"

  # Ignore temporary Office-like files such as "~$example.txt".
  if [[ "$base_name" == '~$'* ]]; then
    continue
  fi

  tmp_file="$(mktemp)"
  git show ":$file" > "$tmp_file"

  if grep -n $'\r' "$tmp_file" >/dev/null; then
    echo "CRLF line endings found in $file"
    has_errors=1
  fi

  if grep -n '[[:blank:]]$' "$tmp_file" >/dev/null; then
    echo "Trailing whitespace found in $file"
    grep -n '[[:blank:]]$' "$tmp_file"
    has_errors=1
  fi

  if grep -n $'\t' "$tmp_file" >/dev/null; then
    echo "Tab characters found in $file"
    grep -n $'\t' "$tmp_file"
    has_errors=1
  fi

  last_char="$(tail -c 1 "$tmp_file" 2>/dev/null || true)"
  if [[ -s "$tmp_file" && -n "$last_char" ]]; then
    echo "Missing newline at end of file: $file"
    has_errors=1
  fi

  rm -f "$tmp_file"
done < <(git diff --cached --name-only --diff-filter=ACMR -z -- '*.txt')

if [[ "$has_errors" -ne 0 ]]; then
  echo
  echo "Commit aborted. Fix the .txt formatting issues and try again."
  exit 1
fi

echo "TXT format check passed."
