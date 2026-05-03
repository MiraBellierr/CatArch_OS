# Mirror and Repository Policy

## Repository Scope
- Arch Linux: `core`, `extra`, `multilib`
- CatArch channels: `catarch-testing`, `catarch`

## Live ISO pacman.conf Contract
- Keep Arch upstream repos enabled in this order: `core`, `extra`, `multilib`.
- Keep CatArch channels below upstream repos.
- Use placeholder mirror format in `archiso/pacman.conf`:
  - `Server = https://mirror.catarch.example/$repo/os/$arch`
- Additional mirrors should be added as extra `Server` lines using the same path contract.

## Sync Cadence
- `catarch-testing`: daily ingest from upstream + CatArch package updates.
- `catarch`: weekly promotion from `catarch-testing` after QA signoff.

## Promotion Gates
Promote from `catarch-testing` to `catarch` only when:
1. Daily smoke tests pass on current ISO candidate.
2. No known P0 regressions in boot, installer, or desktop login.
3. Snapshot and rollback validation is green.

## Emergency Rollback
If a bad update reaches `catarch`, revert repository metadata and publish advisory with snapshot rollback steps.

## Mirror Failure Handling
- If a CatArch mirror is stale or unavailable, move it below healthy mirrors or comment it out.
- Never remove Arch upstream repositories from live ISO as fallback package source.
