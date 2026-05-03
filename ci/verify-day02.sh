#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_paths=(
  "$ROOT_DIR/archiso/profiledef.sh"
  "$ROOT_DIR/archiso/bootstrap_packages"
  "$ROOT_DIR/archiso/grub/grub.cfg"
  "$ROOT_DIR/archiso/grub/loopback.cfg"
  "$ROOT_DIR/archiso/efiboot/loader/loader.conf"
  "$ROOT_DIR/archiso/efiboot/loader/entries/01-catarch-linux.conf"
  "$ROOT_DIR/archiso/efiboot/loader/entries/02-catarch-speech-linux.conf"
  "$ROOT_DIR/archiso/efiboot/loader/entries/03-memtest86+x64.conf"
  "$ROOT_DIR/ci/bootstrap-releng.sh"
)

for p in "${required_paths[@]}"; do
  [[ -f "$p" ]] || { echo "missing: $p"; exit 1; }
  echo "ok: $p"
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

check_contains "$ROOT_DIR/archiso/profiledef.sh" 'iso_name="catarch"'
check_contains "$ROOT_DIR/archiso/profiledef.sh" 'iso_label="CATARCH_'
check_contains "$ROOT_DIR/archiso/profiledef.sh" 'iso_publisher="CatArch OS'
check_contains "$ROOT_DIR/archiso/profiledef.sh" 'iso_application="CatArch OS Live/Rescue Environment"'
check_contains "$ROOT_DIR/archiso/profiledef.sh" 'install_dir="catarch"'
check_contains "$ROOT_DIR/archiso/profiledef.sh" "bootmodes=('uefi.systemd-boot')"

check_contains "$ROOT_DIR/README.md" '# CatArch OS'
check_contains "$ROOT_DIR/calamares/branding/catarch/branding.desc" 'name: CatArch OS'
check_contains "$ROOT_DIR/ci/build-iso.sh" '[catarch]'

echo "day 02 verification passed"
