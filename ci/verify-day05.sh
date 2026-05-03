#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  "$ROOT_DIR/archiso/airootfs/etc/locale.conf"
  "$ROOT_DIR/archiso/airootfs/etc/vconsole.conf"
  "$ROOT_DIR/archiso/airootfs/etc/locale.gen"
  "$ROOT_DIR/archiso/airootfs/etc/pipewire/pipewire.conf.d/10-catarch-live.conf"
  "$ROOT_DIR/archiso/airootfs/etc/sddm.conf.d/catarch.conf"
  "$ROOT_DIR/archiso/airootfs/etc/sddm.conf.d/10-live-test.conf"
  "$ROOT_DIR/archiso/airootfs/etc/systemd/system/multi-user.target.d/10-catarch-live.conf"
  "$ROOT_DIR/archiso/airootfs/etc/systemd/system/graphical.target.d/10-catarch-live.conf"
  "$ROOT_DIR/docs/HARDWARE-SMOKE-SIGNUPS.md"
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

check_contains "$ROOT_DIR/archiso/airootfs/etc/locale.conf" "LANG=en_US.UTF-8"
check_contains "$ROOT_DIR/archiso/airootfs/etc/locale.gen" "en_US.UTF-8 UTF-8"
check_contains "$ROOT_DIR/archiso/airootfs/etc/systemd/system/multi-user.target.d/10-catarch-live.conf" "Wants=NetworkManager.service"
check_contains "$ROOT_DIR/archiso/airootfs/etc/systemd/system/graphical.target.d/10-catarch-live.conf" "Wants=sddm.service"
check_contains "$ROOT_DIR/archiso/airootfs/etc/pipewire/pipewire.conf.d/10-catarch-live.conf" "context.properties = {"
check_contains "$ROOT_DIR/archiso/airootfs/etc/sddm.conf.d/catarch.conf" "DisplayServer=wayland"
check_contains "$ROOT_DIR/docs/HARDWARE-SMOKE-SIGNUPS.md" "Intel"
check_contains "$ROOT_DIR/docs/HARDWARE-SMOKE-SIGNUPS.md" "AMD"
check_contains "$ROOT_DIR/docs/HARDWARE-SMOKE-SIGNUPS.md" "NVIDIA"

echo "day 05 verification passed"
