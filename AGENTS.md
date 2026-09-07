# Agent Guidelines

- **Language**: Strictly English only across all code, comments, notifications, commits, and docs. No Polish words or diacritics.
- **UI Variables**: `archlinux/.config/ui/ui.toml` is the single source of truth for all colors, borders, roundings, gaps, and fonts. Never hardcode styles in component configs or scripts; compile them using `apply-ui`.
- **Consistency**: Maintain the GNU Stow package structure (`common/`, `archlinux/`, `macos/`) mirroring `$HOME`. Shell scripts must be robust (`set -euo pipefail`).
