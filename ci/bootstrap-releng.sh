#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="$ROOT_DIR/archiso"
RELENG_DIR="/usr/share/archiso/configs/releng"

if [[ ! -d "$RELENG_DIR" ]]; then
  echo "Releng profile not found at $RELENG_DIR" >&2
  exit 1
fi

rm -rf "$TARGET_DIR"
cp -a "$RELENG_DIR" "$TARGET_DIR"

PROFILEDEF="$TARGET_DIR/profiledef.sh"
LOADER_DIR="$TARGET_DIR/efiboot/loader"
ENTRY_DIR="$LOADER_DIR/entries"
GRUB_DIR="$TARGET_DIR/grub"

sed -i \
  -e 's|^iso_name=.*|iso_name="catarch"|' \
  -e 's|^iso_label=.*|iso_label="CATARCH_$(date --date=\"@${SOURCE_DATE_EPOCH:-$(date +%s)}\" +%Y%m)"|' \
  -e 's|^iso_publisher=.*|iso_publisher="CatArch OS"|' \
  -e 's|^iso_application=.*|iso_application="CatArch OS Live/Rescue Environment"|' \
  -e 's|^install_dir=.*|install_dir="catarch"|' \
  -e "s|^bootmodes=.*|bootmodes=('uefi.systemd-boot')|" \
  "$PROFILEDEF"

mv "$ENTRY_DIR/01-archiso-linux.conf" "$ENTRY_DIR/01-catarch-linux.conf"
mv "$ENTRY_DIR/02-archiso-speech-linux.conf" "$ENTRY_DIR/02-catarch-speech-linux.conf"
mv "$ENTRY_DIR/03-archiso-memtest86+x64.conf" "$ENTRY_DIR/03-memtest86+x64.conf"

sed -i 's|^default .*|default 01-catarch-linux.conf|' "$LOADER_DIR/loader.conf"
sed -i 's|Arch Linux|CatArch OS|g' "$ENTRY_DIR/01-catarch-linux.conf" "$ENTRY_DIR/02-catarch-speech-linux.conf"
sed -i \
  -e 's|^default=archlinux|default=catarch|' \
  -e "s|--id 'archlinux'|--id 'catarch'|g" \
  -e "s|--id 'archlinux-accessibility'|--id 'catarch-accessibility'|g" \
  -e 's|Arch Linux|CatArch OS|g' \
  "$GRUB_DIR/grub.cfg" "$GRUB_DIR/loopback.cfg"

echo "Releng profile copied and CatArch identity applied: $TARGET_DIR"
