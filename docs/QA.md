# QA Matrix

## Daily Smoke Tests
1. Boot live ISO in UEFI VM.
2. Launch Calamares and reach summary page.
3. Install to Btrfs and boot installed system.
4. Verify KDE session starts.
5. Confirm networking, audio, and package manager basic functionality.

## Weekly Validation
1. Update system and verify snapshots are generated.
2. Reboot into snapshot entry via GRUB.
3. Validate preset switching and persistence.
4. Validate selected profile package set (Base/Developer/Gamer/Creator).
