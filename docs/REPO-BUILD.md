# CatArch Repository Build Guide

This guide explains how to create local `catarch-testing` and `catarch` pacman repositories.

## Why your current build fails

If you see:
- `Could not resolve host: mirror.catarch.example`
- `failed to synchronize all databases`

your profile is still pointing at placeholder mirror URLs in `archiso/pacman.conf`.

## Prerequisites (Arch build host)

```bash
sudo pacman -Syu --needed base-devel devtools pacman-contrib archiso
```

## Step 1: Build local CatArch repositories

From the repo root:

```bash
chmod +x ci/build-catarch-repo.sh ci/promote-testing-to-stable.sh ci/build-iso.sh
./ci/build-catarch-repo.sh --clean
```

This creates:
- `repo/catarch-testing/os/x86_64/`
- `repo/catarch/os/x86_64/`

with `.db` metadata generated via `repo-add`.

## Step 2: Build ISO with local repo mirror base

```bash
./ci/build-iso.sh --clean --catarch-mirror-base "file://$(pwd)/repo"
```

The script creates a temporary pacman config and rewrites CatArch mirrors to:
- `file://<repo-root>/$repo/os/$arch`

No permanent edits are made to `archiso/pacman.conf`.

## Step 3: Promote testing to stable (when ready)

```bash
./ci/promote-testing-to-stable.sh --clean-stable
```

## Optional bootstrap mode (no CatArch repo yet)

If you only need to test ISO plumbing before custom packages:

```bash
./ci/build-iso.sh --clean --skip-catarch-repos
```

This temporarily removes `[catarch-testing]` and `[catarch]` sections from the build config.

## Serving over HTTP instead of file:// (optional)

```bash
cd repo
python -m http.server 8080
```

Then build with:

```bash
./ci/build-iso.sh --clean --catarch-mirror-base "http://127.0.0.1:8080"
```

## Repository layout contract

Mirror base URL must expose:
- `<base>/catarch-testing/os/x86_64/catarch-testing.db`
- `<base>/catarch/os/x86_64/catarch.db`
- package files in each repo directory.
