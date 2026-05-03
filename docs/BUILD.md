# Build Guide

## Host Requirements
- Arch Linux build host (recommended)
- `archiso`, `devtools`, `base-devel`, `rsync`, `squashfs-tools`
- `shellcheck` (recommended for script linting)
- Build from a native Linux filesystem path (for example `/home/<user>/catOS`), not a VM shared folder mount.

## Install Dependencies
```bash
sudo pacman -Syu --needed archiso git base-devel devtools rsync squashfs-tools shellcheck
```

## Step 1: Sync/Refresh Profile (Optional)
Use this when you need to refresh from Arch `releng` baseline:
```bash
./ci/bootstrap-releng.sh
```

## Step 2: Run Baseline Verifiers
```bash
./ci/verify-day02.sh
./ci/verify-day03.sh
./ci/verify-day04.sh
./ci/verify-day05.sh
./ci/verify-day06.sh
./ci/verify-day07.sh
```

## Step 3: Set Deterministic Build Metadata
Pin `SOURCE_DATE_EPOCH` before build so ISO metadata is reproducible:
```bash
export SOURCE_DATE_EPOCH=1735689600
```
Example above corresponds to `2025-01-01 00:00:00 UTC`.

## Step 4: Build ISO
```bash
./ci/build-iso.sh --clean
```

If CatArch placeholder mirrors are not reachable yet:
```bash
./ci/build-catarch-repo.sh --clean
./ci/build-iso.sh --clean --catarch-mirror-base "file://$(pwd)/repo"
```
or temporarily skip CatArch repos:
```bash
./ci/build-iso.sh --clean --skip-catarch-repos
```
See [REPO-BUILD.md](./REPO-BUILD.md) for full repo workflow.

## Build Script Options
```bash
./ci/build-iso.sh --help
```

## Output Paths
- ISO artifacts: `out/`
- Working directory: `work/`

## Shellcheck Suggestions
```bash
shellcheck ci/build-iso.sh ci/bootstrap-releng.sh ci/verify-day*.sh
```

## Deterministic Build Notes
- Use a clean Arch environment (fresh VM or chroot).
- Keep `SOURCE_DATE_EPOCH` fixed across rebuilds.
- Do not edit `archiso/profiledef.sh` timestamp logic ad-hoc during release build.
- Keep `archiso/packages.x86_64` reviewed and stable before release candidates.

## Troubleshooting: Stale `work/` Mounts
If a previous `mkarchiso` run was interrupted, `work/x86_64/airootfs/{dev,proc,run,sys}` may remain mounted.
`./ci/build-iso.sh --clean` now attempts to unmount these automatically before removing `work/`.
If cleanup still fails, run:
```bash
sudo findmnt -R ./work
sudo umount -R ./work
sudo rm -rf ./work
```
