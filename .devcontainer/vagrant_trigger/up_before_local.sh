#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${VBOX_VMS_DIR:-$HOME/VirtualBox VMs}"
TARGET_NAME=""
DRY_RUN=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --root)
      ROOT_DIR="$2"
      shift 2
      ;;
    --name)
      TARGET_NAME="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    *)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
  esac
done

if [[ ! -d "$ROOT_DIR" ]]; then
  echo "VirtualBox VM directory not found: $ROOT_DIR"
  exit 0
fi

shopt -s nullglob
removed=0
checked=0

for dir in "$ROOT_DIR"/*; do
  [[ -d "$dir" ]] || continue
  name="$(basename "$dir")"

  if [[ -n "$TARGET_NAME" && "$name" != "$TARGET_NAME" ]]; then
    continue
  fi

  checked=$((checked + 1))
  vbox_files=("$dir"/*.vbox)

  if (( ${#vbox_files[@]} == 0 )); then
    if (( DRY_RUN == 1 )); then
      echo "[DRY-RUN] removing stale directory: $dir"
    else
      echo "removing stale directory: $dir"
      rm -rf -- "$dir"
    fi
    removed=$((removed + 1))
  fi
done

echo "checked: $checked, removed: $removed"
