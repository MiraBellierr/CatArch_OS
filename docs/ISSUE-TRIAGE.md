# Issue Triage for v1 vs Later Milestones

Day 07 checkpoint workflow for routing open issues into `v1.0.0` or post-v1 milestones.

## Milestone Definitions
- `v1.0.0`: mandatory for first public release.
- `v1.1`: post-release patch and quality improvements.
- `backlog-post-v1`: non-critical feature work and deferred ideas.

## Triage Decision Rules
Route to `v1.0.0` only if at least one is true:
1. Prevents successful boot, install, login, update, or rollback.
2. Security/compliance risk that blocks public release.
3. Breaks an explicit public contract in `PROGRESS.md` v1 plan.

Route to `v1.1` when:
1. Improves reliability/performance/usability but has a valid workaround.
2. Is not required to achieve v1 done criteria.

Route to `backlog-post-v1` when:
1. Adds new feature surface not required by v1 plan.
2. Is a nice-to-have polish item with no release-blocking impact.

## Triage Labels
- Severity: `P0`, `P1`, `P2`.
- Area: `build`, `installer`, `theme`, `qa`, `docs`.
- Freeze tags: `scope-v1`, `deferred-post-v1`.

## Day 07 Triage Register
Use this table when reviewing open issues:

| Issue | Summary | Severity | Milestone | Decision | Owner |
|---|---|---|---|---|---|
| `TBD` | `TBD` | `P0/P1/P2` | `v1.0.0/v1.1/backlog-post-v1` | `keep/defer` | `TBD` |
| `TBD` | `TBD` | `P0/P1/P2` | `v1.0.0/v1.1/backlog-post-v1` | `keep/defer` | `TBD` |
| `TBD` | `TBD` | `P0/P1/P2` | `v1.0.0/v1.1/backlog-post-v1` | `keep/defer` | `TBD` |

## Operating Rule During Freeze
- If an issue is not a release blocker, default outcome is defer to `backlog-post-v1`.
