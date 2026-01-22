#!/usr/bin/env bash
# Usage: ./add_table_separators.sh path/to/BASHRC_README.md
set -euo pipefail

file="${1:-}"
[ -n "$file" ] && [ -f "$file" ] || { echo "Usage: $0 <markdown-file>"; exit 1; }

sep='|---------|--------------|---------|'

awk -v sep="$sep" '
{ lines[NR]=$0 }
END {
  for (i=1; i<=NR; i++) {
    print lines[i]
    # Insert sep after any data row that starts with "|" and isn’t already the sep,
    # as long as the next line is also a table line and isn’t already the sep.
    if (lines[i] ~ /^\|/ && lines[i] != sep) {
      if (i < NR && lines[i+1] ~ /^\|/ && lines[i+1] != sep) {
        print sep
      }
    }
  }
}
' "$file" > "$file.tmp"

mv "$file.tmp" "$file"
echo "Updated: $file"
