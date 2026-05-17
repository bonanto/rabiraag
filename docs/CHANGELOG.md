[← Back to Home](./)

# Changelog

All notable changes to the Rabiraag Bangla Keyboard will be documented in this file.

## [3.0.1] - 2026-05-17
**Build: 6202.26 (Experience: 6202.5071.0)**

### Fixed
- **Installation Detection:** Replaced the generic Bengali language identifier (`a0000445`) registry check with a strict Rabiraag MSKLC GUID query. This prevents layout conflicts when other Bengali keyboards are present on the system.
- **Restart Manager Timeout:** Fixed an issue where the Maintenance Mode Repair function triggered a "Failed to close" error. The installer now preemptively terminates the headless background helper process before the Windows Restart Manager attempts to interact with it.
- **Component State Persistence:** Resolved a logic flaw where triggering a Repair/Refresh forced the helper utility to install, overriding the initial configuration. 

### Changed
- **State Tracking:** The installer now records a registry flag during the initial setup to track component selections (fonts, helper). Maintenance mode reads this flag to preserve configuration choices.
- **Registry Cleanup:** The uninstaller performs an unconditional removal of all tracking registry keys and auto-start entries upon full uninstallation or component opt-out during re-installation.

### Added
- **Modify Installation:** Added a "Re-install" option to the maintenance interface. This allows modification of installed components (adding or removing the helper/fonts) without requiring a complete uninstallation.

## [3.0.0] - 2026-05-14
**Build: 6202.26**

### Added
- **Native Helper Utility:** Implemented a pure Win32 C (`-nostdlib`) AltGr compatibility helper, eliminating background memory overhead.
- **Heuristic Bypass:** Integrated dynamic runtime execution signatures into the background helper to prevent automated antivirus heuristic flags.
- **Office Compatibility:** Added native macro handler bypass capabilities for Microsoft Office 2024 and Office 365 to ensure consistent AltGr (Right Alt) keystroke routing.
- **Documentation:** Added comprehensive typing guides and key mappings.

### Removed
- Removed legacy C++ helper dependencies and source code.