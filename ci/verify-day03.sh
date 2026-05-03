#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  "$ROOT_DIR/archiso/packages.x86_64"
  "$ROOT_DIR/docs/PACKAGE-REVIEW.md"
  "$ROOT_DIR/.github/ISSUE_TEMPLATE/package-review.yml"
)

for f in "${required_files[@]}"; do
  [[ -f "$f" ]] || { echo "missing: $f"; exit 1; }
  echo "ok: $f"
done

check_contains() {
  local file="$1"
  local expected="$2"
  if ! grep -Fq "$expected" "$file"; then
    echo "missing in $file: $expected"
    exit 1
  fi
  echo "ok: $file contains '$expected'"
}

# Day 03 package baseline categories
check_contains "$ROOT_DIR/archiso/packages.x86_64" "# boot + base system"
check_contains "$ROOT_DIR/archiso/packages.x86_64" "# KDE desktop session"
check_contains "$ROOT_DIR/archiso/packages.x86_64" "# networking + bluetooth"
check_contains "$ROOT_DIR/archiso/packages.x86_64" "# audio + media"
check_contains "$ROOT_DIR/archiso/packages.x86_64" "# fonts + localization"
check_contains "$ROOT_DIR/archiso/packages.x86_64" "# firmware + printing"
check_contains "$ROOT_DIR/archiso/packages.x86_64" "# filesystem + rollback stack"

# Representative packages required by Day 03 scope
check_contains "$ROOT_DIR/archiso/packages.x86_64" "plasma-desktop"
check_contains "$ROOT_DIR/archiso/packages.x86_64" "networkmanager"
check_contains "$ROOT_DIR/archiso/packages.x86_64" "pipewire"
check_contains "$ROOT_DIR/archiso/packages.x86_64" "noto-fonts"
check_contains "$ROOT_DIR/archiso/packages.x86_64" "fwupd"
check_contains "$ROOT_DIR/archiso/packages.x86_64" "snapper"

# Review workflow artifacts
check_contains "$ROOT_DIR/docs/PACKAGE-REVIEW.md" "Package Review - Boot and Base System"
check_contains "$ROOT_DIR/docs/PACKAGE-REVIEW.md" "Package Review - Audio and Media"
check_contains "$ROOT_DIR/.github/ISSUE_TEMPLATE/package-review.yml" "name: Package Review"

echo "day 03 verification passed"
