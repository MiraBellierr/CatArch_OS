#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ./ci/build-iso.sh [options]

Options:
  -w, --work-dir <path>   Override mkarchiso work directory.
  -o, --out-dir <path>    Override mkarchiso output directory.
  --catarch-mirror-base <url>
                           Use this base URL for CatArch repos (expects layout <base>/$repo/os/$arch).
  --skip-catarch-repos     Build without [catarch-testing]/[catarch] repositories.
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

normalize_url_base() {
  local url="$1"
  url="${url%/}"
  [[ -n "$url" ]] || die "Empty mirror base URL."
  printf '%s' "$url"
}

prepare_pacman_conf() {
  local source_conf="$1"
  local output_conf="$2"
  local mirror_base="$3"
  local skip_catarch="$4"

  awk -v skip_catarch="$skip_catarch" '
    BEGIN { skip = 0 }
    /^\[catarch-testing\]$/ { if (skip_catarch == "true") { skip = 1; next } }
    /^\[catarch\]$/         { if (skip_catarch == "true") { skip = 1; next } }
    /^\[[^]]+\]$/           { if (skip == 1) skip = 0 }
    { if (skip == 0) print }
  ' "$source_conf" > "$output_conf"

  if [[ -n "$mirror_base" ]]; then
    local server_line
    server_line="Server = ${mirror_base}/\$repo/os/\$arch"
    sed -i \
      -e "s|^Server = https://mirror\\.catarch\\.example/\\\$repo/os/\\\$arch$|$server_line|g" \
      -e "s|^# Server = https://mirror2\\.catarch\\.example/\\\$repo/os/\\\$arch$|$server_line|g" \
      "$output_conf"
  fi
}

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROFILE_DIR="$ROOT_DIR/archiso"
WORK_DIR="${WORK_DIR:-$ROOT_DIR/work}"
OUT_DIR="${OUT_DIR:-$ROOT_DIR/out}"
PACMAN_CONF="$PROFILE_DIR/pacman.conf"
CLEAN=false
USE_SUDO=true
CATARCH_MIRROR_BASE=""
SKIP_CATARCH_REPOS=false
TEMP_PACMAN_CONF=""

cleanup() {
  if [[ -n "$TEMP_PACMAN_CONF" ]] && [[ -f "$TEMP_PACMAN_CONF" ]]; then
    rm -f "$TEMP_PACMAN_CONF"
  fi
}

trap cleanup EXIT

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
    --catarch-mirror-base)
      [[ $# -ge 2 ]] || die "Missing value for $1"
      CATARCH_MIRROR_BASE="$(normalize_url_base "$2")"
      shift 2
      ;;
    --skip-catarch-repos)
      SKIP_CATARCH_REPOS=true
      shift
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

if [[ "$SKIP_CATARCH_REPOS" == true ]] && [[ -n "$CATARCH_MIRROR_BASE" ]]; then
  die "--skip-catarch-repos and --catarch-mirror-base are mutually exclusive."
fi

require_cmd mkarchiso
[[ -d "$PROFILE_DIR" ]] || die "Profile directory not found: $PROFILE_DIR"
[[ -f "$PACMAN_CONF" ]] || die "Pacman config not found: $PACMAN_CONF"

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

if [[ "$SKIP_CATARCH_REPOS" == true ]] || [[ -n "$CATARCH_MIRROR_BASE" ]]; then
  TEMP_PACMAN_CONF="$(mktemp "$WORK_DIR/pacman.conf.XXXXXX")"
  prepare_pacman_conf "$PACMAN_CONF" "$TEMP_PACMAN_CONF" "$CATARCH_MIRROR_BASE" "$SKIP_CATARCH_REPOS"
  PACMAN_CONF="$TEMP_PACMAN_CONF"
  if [[ "$SKIP_CATARCH_REPOS" == true ]]; then
    log "Using temporary pacman config without CatArch repositories."
  else
    log "Using temporary pacman config with CatArch mirror base: $CATARCH_MIRROR_BASE"
  fi
fi

runner=()
if [[ "$USE_SUDO" == true ]] && [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
  require_cmd sudo
  runner=(sudo)
fi

cmd=("${runner[@]}" mkarchiso -v -w "$WORK_DIR" -o "$OUT_DIR" -C "$PACMAN_CONF" "$PROFILE_DIR")
log "Building ISO from $PROFILE_DIR"
log "Command: ${cmd[*]}"
"${cmd[@]}"

log "Build complete. Artifacts in $OUT_DIR"
