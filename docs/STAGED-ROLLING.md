# Staged Rolling Update Policy

## Channels
- `catarch-testing`: daily ingest from Arch upstream + CatArch package updates.
- `catarch`: weekly promotion after QA pass.

## Promotion Rule
Promote from `catarch-testing` to `catarch` only when:
1. Daily smoke tests pass on current candidate.
2. No known P0 regressions for installer, boot, or desktop login.
3. Snapshot and rollback tests pass.

## Advisories
Each promotion should publish:
- Included updates
- Known issues
- Rollback instructions
