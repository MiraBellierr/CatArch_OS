#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  "$ROOT_DIR/docs/SCOPE-FREEZE-V1.md"
  "$ROOT_DIR/docs/POST-V1-BACKLOG.md"
  "$ROOT_DIR/docs/ISSUE-TRIAGE.md"
  "$ROOT_DIR/CONTRIBUTING.md"
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

# Scope freeze
check_contains "$ROOT_DIR/docs/SCOPE-FREEZE-V1.md" "Scope freeze date:"
check_contains "$ROOT_DIR/docs/SCOPE-FREEZE-V1.md" "## In Scope for v1.0.0"
check_contains "$ROOT_DIR/docs/SCOPE-FREEZE-V1.md" "## Out of Scope for v1.0.0"
check_contains "$ROOT_DIR/docs/SCOPE-FREEZE-V1.md" "## Scope Change Rule"

# Post-v1 backlog
check_contains "$ROOT_DIR/docs/POST-V1-BACKLOG.md" "## Priority P1"
check_contains "$ROOT_DIR/docs/POST-V1-BACKLOG.md" "## Priority P2"
check_contains "$ROOT_DIR/docs/POST-V1-BACKLOG.md" "## Priority P3"

# Issue triage
check_contains "$ROOT_DIR/docs/ISSUE-TRIAGE.md" "## Milestone Definitions"
check_contains "$ROOT_DIR/docs/ISSUE-TRIAGE.md" "## Triage Decision Rules"
check_contains "$ROOT_DIR/docs/ISSUE-TRIAGE.md" "## Day 07 Triage Register"
check_contains "$ROOT_DIR/docs/ISSUE-TRIAGE.md" "v1.0.0"
check_contains "$ROOT_DIR/docs/ISSUE-TRIAGE.md" "backlog-post-v1"

# Contribution guidance and progress marker
check_contains "$ROOT_DIR/CONTRIBUTING.md" "## Scope Freeze"
check_contains "$ROOT_DIR/PROGRESS.md" "- [x] Day 07"

echo "day 07 verification passed"
