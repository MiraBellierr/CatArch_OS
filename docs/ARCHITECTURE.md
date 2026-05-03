# Architecture Notes

## Distribution Model
- Base: Arch Linux (`core`, `extra`, `multilib`)
- CatArch channels: `catarch-testing`, `catarch`
- Desktop: KDE Plasma
- Filesystem: Btrfs with snapshot-first defaults

## Installer
- Calamares with profile selector for Beginner/Developer/Gamer/Creator
- Guided Btrfs subvolumes: `@`, `@home`, `@var_log`, `@var_cache_pacman`, `@snapshots`

## Public Config Contracts
- Presets: `/usr/share/catarch/presets/*.yaml`
- User config: `~/.config/catarch/`
- CLI: `pawctl`

## Initial Package Baseline
See `archiso/packages.x86_64`.

## Next Build Priorities
1. Replace profiledef from local template with upstream releng-derived profile.
2. Integrate full Calamares module payloads used by target ISO.
3. Implement functional theme application hooks behind `pawctl preset apply`.
4. Add real CI build runner with Arch container/host and artifact publishing.
