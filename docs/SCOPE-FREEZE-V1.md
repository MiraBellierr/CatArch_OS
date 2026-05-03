# v1 Scope Freeze (Day 07)

Scope freeze date: `2026-05-03`

This document locks what ships in `v1.0.0` and what is explicitly deferred to post-v1.

## In Scope for v1.0.0
- Platform: UEFI `x86_64` only.
- Desktop: KDE Plasma (Wayland default).
- Installer: Calamares flow with baseline module sequence and Btrfs-first install path.
- Filesystem baseline: Btrfs subvolume layout + snapshot toolchain integration.
- Live ISO baseline: locale, networking, audio, SDDM, package repositories, deterministic build path.
- Theme baseline: CatArch preset system and default themed experience.
- Profile baseline: Beginner, Developer, Gamer, Creator package/profile paths as defined in plan.
- Release engineering baseline: reproducible build notes, checksum/signature workflow, release docs.

## Out of Scope for v1.0.0
- Non-KDE first-class desktop editions.
- Non-UEFI or non-`x86_64` platforms.
- Large new feature tracks not already present in the 42-day plan.
- Architectural rewrites of installer/theme/profile systems during stabilization.

## Explicit Deferrals
- Hyprland pack is post-install optional work, not a v1 ship blocker.
- Additional visual presets beyond the listed v1 set move to post-v1.
- Extended onboarding polish beyond v1 critical-path usability fixes moves to post-v1.

## Scope Change Rule
- New work can enter v1 only if it is:
  - A release blocker fix (`P0`) for boot, installer, login, rollback, or update safety.
  - A security fix required for public release readiness.
- All non-blocking ideas must be moved to `docs/POST-V1-BACKLOG.md`.
