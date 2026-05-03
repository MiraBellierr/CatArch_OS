#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ./ci/promote-testing-to-stable.sh [options]

Options:
  --repo-root <path>  Repository root (default: ./repo).
  --arch <arch>       Repository architecture (default: x86_64).
  --clean-stable      Remove stable packages before republishing.
  -h, --help          Show this help text.
EOF
}

log() {
  printf '[catarch-promote] %s\n' "$*"
}

die() {
  printf '[catarch-promote] ERROR: %s\n' "$*" >&2
  exit 1
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "Required command not found: $1"
}

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_ROOT="${REPO_ROOT:-$ROOT_DIR/repo}"
ARCH_NAME="${ARCH_NAME:-x86_64}"
CLEAN_STABLE=false

while (($#)); do
  case "$1" in
    --repo-root)
      [[ $# -ge 2 ]] || die "Missing value for $1"
      REPO_ROOT="$2"
      shift 2
      ;;
    --arch)
      [[ $# -ge 2 ]] || die "Missing value for $1"
      ARCH_NAME="$2"
      shift 2
      ;;
    --clean-stable)
      CLEAN_STABLE=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "Unknown option: $1"
      ;;
  esac
done

require_cmd repo-add

TESTING_DIR="$REPO_ROOT/catarch-testing/os/$ARCH_NAME"
STABLE_DIR="$REPO_ROOT/catarch/os/$ARCH_NAME"

[[ -d "$TESTING_DIR" ]] || die "Testing repo directory not found: $TESTING_DIR"
mkdir -p "$STABLE_DIR"

if [[ "$CLEAN_STABLE" == true ]]; then
  log "Cleaning stable directory: $STABLE_DIR"
  find "$STABLE_DIR" -maxdepth 1 -type f \( -name '*.pkg.tar.*' -o -name 'catarch.db*' -o -name 'catarch.files*' \) -delete
fi

mapfile -t pkgs < <(find "$TESTING_DIR" -maxdepth 1 -type f \( -name '*.pkg.tar.zst' -o -name '*.pkg.tar.xz' -o -name '*.pkg.tar.gz' \) | sort)

[[ "${#pkgs[@]}" -gt 0 ]] || die "No package artifacts found in testing repository."

cp -f "${pkgs[@]}" "$STABLE_DIR/"
mapfile -t stable_pkgs < <(find "$STABLE_DIR" -maxdepth 1 -type f \( -name '*.pkg.tar.zst' -o -name '*.pkg.tar.xz' -o -name '*.pkg.tar.gz' \) | sort)
repo-add -R "$STABLE_DIR/catarch.db.tar.zst" "${stable_pkgs[@]}"
ln -sf catarch.db.tar.zst "$STABLE_DIR/catarch.db"
ln -sf catarch.files.tar.zst "$STABLE_DIR/catarch.files"

log "Promoted testing -> stable successfully."
