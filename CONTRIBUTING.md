# Contributing to CatArch OS

## Workflow
1. Pick one unchecked day from `PROGRESS.md`.
2. Open issue title: `Day XX - <goal>`.
3. Keep PR scope limited to that day or one tightly related fix.
4. Include test evidence (logs, screenshots, or command output summary).

## Scope Freeze
- v1 scope freeze is defined in `docs/SCOPE-FREEZE-V1.md`.
- Non-critical feature work must be routed to `docs/POST-V1-BACKLOG.md`.
- Issue routing rules are defined in `docs/ISSUE-TRIAGE.md`.

## Labels
Use these labels on issues and PRs:
- `build`
- `theme`
- `installer`
- `qa`
- `docs`
- `good-first-issue`

Task board columns and card flow are defined in `docs/PROJECT-BOARD.md`.

## Branch Naming
- `day-xx-short-topic`
- Example: `day-08-calamares-scaffold`

## PR Checklist
- Scope:
- Files changed:
- Test evidence:
- Rollback plan:
- Risks:

## Merge Gate
- At least one reviewer approval
- Required checks passing
- No unresolved blocking comments

## Coding Notes
- Prefer ASCII unless file already uses Unicode.
- Keep changes small and reviewable.
- Document behavior changes in `docs/` when relevant.
