#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ./ci/build-catarch-repo.sh [options]

Options:
  --repo-root <path>      Repository root output (default: ./repo).
  --packages-root <path>  Root containing package directories (default: ./packages).
  --arch <arch>           Repository architecture (default: x86_64).
  --no-build              Skip makepkg; only index existing package files.
  --clean                 Remove existing repo root before generating.
  -h, --help              Show this help text.

Output layout:
  <repo-root>/
    pool/
    catarch-testing/os/<arch>/
    catarch/os/<arch>/
EOF
}

log() {
  printf '[catarch-repo] %s\n' "$*"
}

die() {
  printf '[catarch-repo] ERROR: %s\n' "$*" >&2
  exit 1
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "Required command not found: $1"
}

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_ROOT="${REPO_ROOT:-$ROOT_DIR/repo}"
PACKAGES_ROOT="${PACKAGES_ROOT:-$ROOT_DIR/packages}"
ARCH_NAME="${ARCH_NAME:-x86_64}"
DO_BUILD=true
CLEAN=false

while (($#)); do
  case "$1" in
    --repo-root)
      [[ $# -ge 2 ]] || die "Missing value for $1"
      REPO_ROOT="$2"
      shift 2
      ;;
    --packages-root)
      [[ $# -ge 2 ]] || die "Missing value for $1"
      PACKAGES_ROOT="$2"
      shift 2
      ;;
    --arch)
      [[ $# -ge 2 ]] || die "Missing value for $1"
      ARCH_NAME="$2"
      shift 2
      ;;
    --no-build)
      DO_BUILD=false
      shift
      ;;
    --clean)
      CLEAN=true
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
require_cmd find

if [[ "$DO_BUILD" == true ]]; then
  require_cmd makepkg
fi

[[ -d "$PACKAGES_ROOT" ]] || die "Packages root not found: $PACKAGES_ROOT"

if [[ "$CLEAN" == true ]]; then
  log "Cleaning repo root: $REPO_ROOT"
  rm -rf "$REPO_ROOT"
fi

POOL_DIR="$REPO_ROOT/pool"
TESTING_DIR="$REPO_ROOT/catarch-testing/os/$ARCH_NAME"
STABLE_DIR="$REPO_ROOT/catarch/os/$ARCH_NAME"

mkdir -p "$POOL_DIR" "$TESTING_DIR" "$STABLE_DIR"

if [[ "$DO_BUILD" == true ]]; then
  log "Building packages from PKGBUILD directories under $PACKAGES_ROOT"
  while IFS= read -r pkgbuild; do
    pkg_dir="$(dirname "$pkgbuild")"
    log "Building: $pkg_dir"
    (
      cd "$pkg_dir"
      makepkg --syncdeps --clean --cleanbuild --force --noconfirm
    )
  done < <(find "$PACKAGES_ROOT" -mindepth 2 -maxdepth 2 -type f -name PKGBUILD | sort)
fi

log "Collecting package artifacts into pool"
shopt -s nullglob
mapfile -t built_pkgs < <(find "$PACKAGES_ROOT" -type f \( -name '*.pkg.tar.zst' -o -name '*.pkg.tar.xz' -o -name '*.pkg.tar.gz' \) ! -name '*-debug-*' | sort)
shopt -u nullglob

[[ "${#built_pkgs[@]}" -gt 0 ]] || die "No package artifacts found under $PACKAGES_ROOT. Build packages first or pass directories with built packages."

for pkg in "${built_pkgs[@]}"; do
  cp -f "$pkg" "$POOL_DIR/"
  if [[ -f "${pkg}.sig" ]]; then
    cp -f "${pkg}.sig" "$POOL_DIR/"
  fi
done

mapfile -t repo_pkgs < <(find "$POOL_DIR" -maxdepth 1 -type f \( -name '*.pkg.tar.zst' -o -name '*.pkg.tar.xz' -o -name '*.pkg.tar.gz' \) | sort)
[[ "${#repo_pkgs[@]}" -gt 0 ]] || die "No package files in pool directory: $POOL_DIR"

log "Publishing catarch-testing database"
cp -f "${repo_pkgs[@]}" "$TESTING_DIR/"
mapfile -t testing_pkgs < <(find "$TESTING_DIR" -maxdepth 1 -type f \( -name '*.pkg.tar.zst' -o -name '*.pkg.tar.xz' -o -name '*.pkg.tar.gz' \) | sort)
repo-add -R "$TESTING_DIR/catarch-testing.db.tar.zst" "${testing_pkgs[@]}"
ln -sf catarch-testing.db.tar.zst "$TESTING_DIR/catarch-testing.db"
ln -sf catarch-testing.files.tar.zst "$TESTING_DIR/catarch-testing.files"

log "Publishing catarch database (mirrors testing by default)"
cp -f "${repo_pkgs[@]}" "$STABLE_DIR/"
mapfile -t stable_pkgs < <(find "$STABLE_DIR" -maxdepth 1 -type f \( -name '*.pkg.tar.zst' -o -name '*.pkg.tar.xz' -o -name '*.pkg.tar.gz' \) | sort)
repo-add -R "$STABLE_DIR/catarch.db.tar.zst" "${stable_pkgs[@]}"
ln -sf catarch.db.tar.zst "$STABLE_DIR/catarch.db"
ln -sf catarch.files.tar.zst "$STABLE_DIR/catarch.files"

log "Repository build complete: $REPO_ROOT"
log "Use this mirror base with build-iso:"
log "  --catarch-mirror-base file://$REPO_ROOT"
