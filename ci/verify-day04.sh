#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  "$ROOT_DIR/archiso/pacman.conf"
  "$ROOT_DIR/docs/MIRROR-POLICY.md"
)

for f in "${required_files[@]}"; do
  [[ -f "$f" ]] || { echo "missing: $f"; exit 1; }
  echo "ok: $f"
done

check_contains() {
  local file="$1"
  local expected="$2"
  if ! grep -Fq -- "$expected" "$file"; then
    echo "missing in $file: $expected"
    exit 1
  fi
  echo "ok: $file contains '$expected'"
}

PACMAN="$ROOT_DIR/archiso/pacman.conf"
POLICY="$ROOT_DIR/docs/MIRROR-POLICY.md"

check_contains "$PACMAN" "[core]"
check_contains "$PACMAN" "[extra]"
check_contains "$PACMAN" "[multilib]"
check_contains "$PACMAN" "[catarch-testing]"
check_contains "$PACMAN" "[catarch]"
check_contains "$PACMAN" 'Server = https://mirror.catarch.example/$repo/os/$arch'

check_contains "$POLICY" "Repository Scope"
check_contains "$POLICY" "Live ISO pacman.conf Contract"
check_contains "$POLICY" "Sync Cadence"
check_contains "$POLICY" "Promotion Gates"
check_contains "$POLICY" "Emergency Rollback"

echo "day 04 verification passed"
