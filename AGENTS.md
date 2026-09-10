# Agent Guidelines

- **Language**: Strictly English only across all code, comments, notifications,
  commits, and docs. No Polish words or diacritics.
- **UI Variables**: `archlinux/.config/ui/ui.toml` is the single source of truth
  for all colors, borders, roundings, gaps, and fonts. Never hardcode styles in
  component configs or scripts; compile them using `apply-ui`.
- **Consistency**: Maintain the GNU Stow package structure (`common/`,
  `archlinux/`, `macos/`) mirroring `$HOME`. Shell scripts must be robust
  (`set -euo pipefail`).
- **SwayNC CSS**: Never use `all: unset` on structural nodes
  (`.notification-row`, `.notification-background`,
  `.notification-default-action`); it breaks button hit-testing and replays
  the show animation on hover. No CSS keyframe animations on
  `.notification-row` (show/hide is a Revealer crossfade driven by
  `transition-time`). Never put margin/padding on the
  `.floating-notifications` container; offset floating notifications with
  row-level margins only (e.g. `.floating-notifications
  .notification-row:first-child`), otherwise action buttons render but never
  receive clicks.
