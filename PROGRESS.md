# PROGRESS.md - CatArch OS v1 (42-Day Daily Build Plan)

## Summary
- Goal: ship a beginner-friendly, cat-themed Arch-based KDE distro that is practical for daily use.
- Delivery model: KDE-first, curated CatArch repo, staged rolling updates, UEFI x86_64.
- Work style: each day has build tasks, contribution tasks, and a clear done outcome.

## Public Interfaces / Contracts To Freeze Early
- `pawctl` CLI:
  - `pawctl preset list`
  - `pawctl preset apply <id>`
  - `pawctl mode set beginner|advanced`
  - `pawctl mascot enable|disable`
  - `pawctl sounds enable|disable`
- Preset manifests in `/usr/share/catarch/presets/*.yaml`.
- User config path `~/.config/catarch/`.
- System profiles: `Beginner`, `Developer`, `Gamer`, `Creator` selectable at install/onboarding.

## Daily Tracker
Use this as the top-level checklist. Each day should have one issue and one merged PR.

- [x] Day 01
- [x] Day 02
- [x] Day 03
- [x] Day 04
- [x] Day 05
- [x] Day 06
- [x] Day 07
- [ ] Day 08
- [ ] Day 09
- [ ] Day 10
- [ ] Day 11
- [ ] Day 12
- [ ] Day 13
- [ ] Day 14
- [ ] Day 15
- [ ] Day 16
- [ ] Day 17
- [ ] Day 18
- [ ] Day 19
- [ ] Day 20
- [ ] Day 21
- [ ] Day 22
- [ ] Day 23
- [ ] Day 24
- [ ] Day 25
- [ ] Day 26
- [ ] Day 27
- [ ] Day 28
- [ ] Day 29
- [ ] Day 30
- [ ] Day 31
- [ ] Day 32
- [ ] Day 33
- [ ] Day 34
- [ ] Day 35
- [ ] Day 36
- [ ] Day 37
- [ ] Day 38
- [ ] Day 39
- [ ] Day 40
- [ ] Day 41
- [ ] Day 42

## Week 1 - Foundation
| Day | Build Tasks | Contribution Tasks | Done Criteria |
|---|---|---|---|
| Day 01 | Initialize repo structure (`archiso/`, `calamares/`, `packages/`, `presets/`, `docs/`, `ci/`). | Create `CONTRIBUTING.md`, issue labels, task board columns. | Skeleton exists and team can pick tasks. |
| Day 02 | Copy `archiso releng` base profile and set `profiledef.sh` identity values for CatArch OS. | Validate naming consistency across docs and build metadata. | Custom profile builds directory-ready without edits pending. |
| Day 03 | Draft `packages.x86_64` baseline for boot, KDE, network, audio, fonts, firmware, snapshot stack. | Open package review issues for each app category. | Baseline package list approved. |
| Day 04 | Prepare live ISO `pacman.conf` with `core/extra/multilib` and placeholders for `[catarch]` repos. | Draft mirror policy doc for staged rolling. | Repo config reviewed and documented. |
| Day 05 | Add initial `airootfs` live settings (locale, NM enabled, PipeWire defaults, SDDM test config). | Hardware smoke volunteer signups (Intel/AMD/NVIDIA). | Live environment config boots to desktop on VM. |
| Day 06 | Add first build script and deterministic build notes in `docs/BUILD.md`. | Improve script readability, add shellcheck suggestions. | Build command path is documented end-to-end. |
| Day 07 | Weekly checkpoint: lock v1 scope and defer non-critical features to post-v1 backlog. | Triage all open issues into v1 vs later milestones. | Scope freeze complete. |

## Week 2 - Installer + Filesystem + Rollback
| Day | Build Tasks | Contribution Tasks | Done Criteria |
|---|---|---|---|
| Day 08 | Integrate Calamares base config and branding folder scaffold. | Supply slideshow copy/text for beginner flow. | Calamares launches in live session. |
| Day 09 | Configure Calamares modules order (`welcome`, `locale`, `keyboard`, `partition`, `users`, `packagechooser`, `summary`, install modules). | Review module flow for beginner clarity. | Installer flow finalized for v1. |
| Day 10 | Implement Btrfs guided layout defaults (`@`, `@home`, `@var_log`, `@var_cache_pacman`, `@snapshots`). | Validate partitioning expectations on clean disk + dual-boot test cases. | Partition plan accepted and documented. |
| Day 11 | Add snapshot stack defaults (`snapper`, `snap-pac`, `grub-btrfs`, `btrfs-assistant`). | Draft rollback safety guide. | Automatic pre/post update snapshots verified in test install. |
| Day 12 | Add GRUB defaults for snapshot menu visibility and sane timeout behavior. | Test boot menu readability on 1080p and 4K. | Snapshot boot entries visible after updates. |
| Day 13 | Add install-time toggles: LTS kernel, NVIDIA path, Flatpak enable, profile selection seed. | UX text polish for toggle descriptions. | Toggles appear and map to package sets. |
| Day 14 | Weekly checkpoint: full install test in VM with rollback validation. | Log bugs and assign owners for Week 3. | Installer + rollback baseline is stable. |

## Week 3 - Core Cat Desktop Theme System
| Day | Build Tasks | Contribution Tasks | Done Criteria |
|---|---|---|---|
| Day 15 | Create CatArch theme package scaffold (Plasma, color schemes, GTK bridge, Kvantum). | Submit color accessibility feedback for each preset. | Theme package builds locally. |
| Day 16 | Build preset 1: `Strawberry Milk` (light+dark). | Icon/wallpaper matching suggestions. | Preset applies coherently across Plasma + GTK. |
| Day 17 | Build preset 2: `Blueberry Moon` (light+dark). | QA contrast checks and legibility report. | Preset passes readability check. |
| Day 18 | Build preset 3: `Matcha Paw` (light+dark). | Validate on laptop + external display. | Preset consistent on multi-monitor. |
| Day 19 | Build preset 4: `Lavender Nap` (light+dark). | Cursor and notification styling review. | Preset includes shell, cursor, notifications style. |
| Day 20 | Build preset 5: `Midnight Neko` (dark-first with light variant). | Battery/eye-strain feedback on dark variant. | Preset finalized with contrast-safe defaults. |
| Day 21 | Weekly checkpoint: lock preset manifest schema and file naming contract. | Create preset contribution template. | Preset contract frozen for v1. |

## Week 4 - Paw Control Center + Mascot + UX Details
| Day | Build Tasks | Contribution Tasks | Done Criteria |
|---|---|---|---|
| Day 22 | Scaffold `paw-control-center` app and settings model. | UI copy pass for beginner and advanced modes. | App opens and reads preset manifests. |
| Day 23 | Implement one-click preset switch and persistence. | Add failure-state UX text for missing assets. | Switching works without manual edits. |
| Day 24 | Implement toggles: sounds, animations, mascot, light/dark mode. | Test toggles across reboot/login cycle. | Toggle state persists correctly. |
| Day 25 | Implement panel layout presets (`cozy-bottom`, `compact-top`, `wide-dock`). | Propose one extra layout and benchmark usability. | Layout switching works safely. |
| Day 26 | Integrate mascot (`Neko Companion`) basic idle animation and disable option. | Provide mascot animation assets and QA frame pacing. | Mascot can be enabled/disabled cleanly. |
| Day 27 | Add cat-themed notifications, launcher polish, paw cursor defaults, terminal prompt theme. | Review theme consistency checklist. | Desktop feels cohesive end-to-end. |
| Day 28 | Weekly checkpoint: usability pass for new Linux user first hour. | Collect feedback and rank fixes P0/P1/P2. | Beginner UX action list finalized. |

## Week 5 - App Stack, Developer/Gaming Profiles, Security/Perf
| Day | Build Tasks | Contribution Tasks | Done Criteria |
|---|---|---|---|
| Day 29 | Finalize default apps (browser, media, file manager, notes, screenshot, monitor). | Validate app startup time and memory footprint. | Daily-use app set locked. |
| Day 30 | Implement Developer profile package set and post-install helper script. | Test Node/Python/Rust/Go/DB toolchain installs. | Developer profile installs without breakage. |
| Day 31 | Implement Gaming profile package set and helpers (Steam/Proton/Lutris/Heroic/MangoHud/GameMode/Wine). | GPU owners validate launch path on Intel/AMD/NVIDIA. | Gaming profile functional on at least 2 GPU vendors. |
| Day 32 | Integrate Flatpak onboarding + Flathub opt-in flow for beginners. | UX review for app-source explanation text. | Flatpak flow works and stays optional. |
| Day 33 | Apply balanced security defaults (firewall, sudo policy, root login default off, fwupd). | Security review checklist and risk notes. | Security baseline documented and enabled. |
| Day 34 | Apply desktop performance defaults (zram, sane sysctl, service pruning, power profiles). | Collect boot/login/app-launch benchmark numbers. | Performance baseline established. |
| Day 35 | Weekly checkpoint: run profile matrix (Base/Dev/Gaming/Creator) install tests. | File bug triage and owner assignment. | Profile matrix issues prioritized. |

## Week 6 - QA, Release Engineering, Branding Ship
| Day | Build Tasks | Contribution Tasks | Done Criteria |
|---|---|---|---|
| Day 36 | Build CI pipeline for ISO + checksums + signatures + artifact manifest. | Improve CI logs and failure summaries. | Nightly build pipeline is green. |
| Day 37 | Add staged rolling workflow docs (`catarch-testing` daily ingest, stable weekly promotion). | Draft release notes template and advisory format. | Update strategy ready for ops. |
| Day 38 | Complete branding deliverables (logo pack, mascot pack, wallpaper pack, splash/login assets). | Submit final asset QA for resolutions and licensing metadata. | Branding assets release-ready. |
| Day 39 | Run full regression: install, update, rollback, theme switch, profile toggles, gaming smoke, dev smoke. | Cross-hardware bug bash day. | P0 bugs closed or blocked with workaround. |
| Day 40 | Write final docs (`README`, install guide, rollback guide, known issues, troubleshooting). | Copyedit and newcomer clarity review. | Docs complete for public release. |
| Day 41 | Release candidate build (`RC1`) and final acceptance checklist run. | Community RC testing and issue confirmation. | RC signoff achieved. |
| Day 42 | Tag `v1.0.0`, publish ISO + signatures + notes, open post-release patch milestone. | Open good-first-issue tasks for v1.1 roadmap. | CatArch OS v1 publicly released. |

## Daily Contribution Workflow (for every day)
- Open a daily issue: `Day XX - <goal>`.
- Assign labels: `build`, `theme`, `installer`, `qa`, `docs`, `good-first-issue`.
- Require PR template fields: scope, screenshots/logs, test evidence, rollback plan.
- Merge gate: at least one reviewer approval and passing build/test checks.

## Test Plan (minimum)
1. ISO boot on UEFI VM and one physical machine.
2. Calamares install path for auto partition, manual partition, and encrypted install.
3. Snapshot creation pre/post update and GRUB snapshot boot entry visibility.
4. Preset switch correctness across Qt, GTK, icons, cursor, sounds, terminal.
5. Developer and Gaming profiles install and basic smoke commands.
6. First-boot beginner flow and accessibility toggle verification.
7. Update from previous nightly without broken boot/session.

## Assumptions and Defaults
- Timeline fixed to 42 days.
- Team can run at least one nightly ISO build and one daily smoke test.
- v1 scope is KDE-first only; Hyprland pack is post-install optional work.
- Target platform is UEFI x86_64 only for v1.
