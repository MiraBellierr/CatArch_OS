#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ./ci/build-iso.sh [options]

Options:
  -w, --work-dir <path>   Override mkarchiso work directory.
  -o, --out-dir <path>    Override mkarchiso output directory.
  --clean                 Remove work directory before building.
  --no-sudo               Run mkarchiso directly (do not prepend sudo).
  -h, --help              Show this help text.

Environment:
  SOURCE_DATE_EPOCH       Unix timestamp used by profile metadata for reproducible labels/versions.
EOF
}

log() {
  printf '[catarch] %s\n' "$*"
}

die() {
  printf '[catarch] ERROR: %s\n' "$*" >&2
  exit 1
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "Required command not found: $1"
}

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROFILE_DIR="$ROOT_DIR/archiso"
WORK_DIR="${WORK_DIR:-$ROOT_DIR/work}"
OUT_DIR="${OUT_DIR:-$ROOT_DIR/out}"
CLEAN=false
USE_SUDO=true

while (($#)); do
  case "$1" in
    -w|--work-dir)
      [[ $# -ge 2 ]] || die "Missing value for $1"
      WORK_DIR="$2"
      shift 2
      ;;
    -o|--out-dir)
      [[ $# -ge 2 ]] || die "Missing value for $1"
      OUT_DIR="$2"
      shift 2
      ;;
    --clean)
      CLEAN=true
      shift
      ;;
    --no-sudo)
      USE_SUDO=false
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

require_cmd mkarchiso
[[ -d "$PROFILE_DIR" ]] || die "Profile directory not found: $PROFILE_DIR"

if [[ -z "${SOURCE_DATE_EPOCH:-}" ]]; then
  log "SOURCE_DATE_EPOCH is not set. Build metadata will use current time."
else
  [[ "$SOURCE_DATE_EPOCH" =~ ^[0-9]+$ ]] || die "SOURCE_DATE_EPOCH must be a Unix timestamp."
  log "Using SOURCE_DATE_EPOCH=$SOURCE_DATE_EPOCH"
fi

if [[ "$CLEAN" == true ]]; then
  log "Cleaning work directory: $WORK_DIR"
  rm -rf "$WORK_DIR"
fi

mkdir -p "$WORK_DIR" "$OUT_DIR"

runner=()
if [[ "$USE_SUDO" == true ]] && [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
  require_cmd sudo
  runner=(sudo)
fi

cmd=("${runner[@]}" mkarchiso -v -w "$WORK_DIR" -o "$OUT_DIR" "$PROFILE_DIR")
log "Building ISO from $PROFILE_DIR"
log "Command: ${cmd[*]}"
"${cmd[@]}"

log "Build complete. Artifacts in $OUT_DIR"
