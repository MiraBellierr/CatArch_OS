#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  "$ROOT_DIR/archiso/profiledef.sh"
  "$ROOT_DIR/archiso/packages.x86_64"
  "$ROOT_DIR/archiso/pacman.conf"
  "$ROOT_DIR/calamares/settings.conf"
  "$ROOT_DIR/PROGRESS.md"
)

for f in "${required_files[@]}"; do
  [[ -f "$f" ]] || { echo "Missing required file: $f"; exit 1; }
  echo "ok: $f"
done

echo "smoke checks passed"
