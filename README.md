# CatArch OS

CatArch OS is a cozy, cat-themed Arch Linux distribution focused on beginner-friendly daily use.

## Current Status
- Execution plan is tracked in [PROGRESS.md](./PROGRESS.md).
- Repo currently contains the v1 scaffold for archiso, Calamares, presets, CI, and docs.
- v1 scope freeze and post-v1 backlog are tracked in `docs/SCOPE-FREEZE-V1.md` and `docs/POST-V1-BACKLOG.md`.

## v1 Product Direction
- Desktop: KDE Plasma (Wayland default)
- Base: Arch Linux with curated CatArch repo
- Update model: staged rolling (`catarch-testing` -> `catarch`)
- Platform: UEFI x86_64

## Quick Start (Build Host)
```bash
sudo pacman -Syu --needed archiso git base-devel devtools rsync squashfs-tools
./ci/build-iso.sh
```

## Local Repository Bootstrap
If CatArch mirror placeholders are unresolved, build local repos first:
```bash
./ci/build-catarch-repo.sh --clean
./ci/build-iso.sh --clean --catarch-mirror-base "file://$(pwd)/repo"
```
Full instructions: [docs/REPO-BUILD.md](./docs/REPO-BUILD.md)

## Repository Layout
- `archiso/` ISO profile and live filesystem overlays
- `calamares/` installer config and branding
- `packages/` custom CatArch package sources
- `presets/` theme manifest presets
- `dotfiles/` default user config templates
- `docs/` build, QA, release, and policy docs
- `ci/` build and release automation scripts

## Contribution
Read [CONTRIBUTING.md](./CONTRIBUTING.md) and claim the next unchecked day in [PROGRESS.md](./PROGRESS.md).
