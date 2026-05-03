#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  "$ROOT_DIR/ci/build-iso.sh"
  "$ROOT_DIR/docs/BUILD.md"
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

# Build script readability + shellcheck-friendly structure
check_contains "$ROOT_DIR/ci/build-iso.sh" "set -euo pipefail"
check_contains "$ROOT_DIR/ci/build-iso.sh" "usage()"
check_contains "$ROOT_DIR/ci/build-iso.sh" "require_cmd()"
check_contains "$ROOT_DIR/ci/build-iso.sh" "--work-dir"
check_contains "$ROOT_DIR/ci/build-iso.sh" "--out-dir"
check_contains "$ROOT_DIR/ci/build-iso.sh" "SOURCE_DATE_EPOCH"
check_contains "$ROOT_DIR/ci/build-iso.sh" "mkarchiso -v -w"

# Build guide end-to-end path + deterministic notes
check_contains "$ROOT_DIR/docs/BUILD.md" "Step 1: Sync/Refresh Profile"
check_contains "$ROOT_DIR/docs/BUILD.md" "Step 2: Run Baseline Verifiers"
check_contains "$ROOT_DIR/docs/BUILD.md" "Step 3: Set Deterministic Build Metadata"
check_contains "$ROOT_DIR/docs/BUILD.md" "Step 4: Build ISO"
check_contains "$ROOT_DIR/docs/BUILD.md" "Shellcheck Suggestions"
check_contains "$ROOT_DIR/docs/BUILD.md" "./ci/build-iso.sh --clean"

echo "day 06 verification passed"
