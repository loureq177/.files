# Agent Guidelines

- **Language**: Strictly English only across all code, comments, notifications,
  commits, and docs. No Polish words or diacritics.
- **UI Variables**: `archlinux/.config/ui/ui.toml` is the single source of truth
  for all colors, borders, roundings, gaps, and fonts. Never hardcode styles in
  component configs or scripts; compile them using `apply-ui`.
- **Consistency**: Maintain the GNU Stow package structure (`common/`,
  `archlinux/`, `macos/`) mirroring `$HOME`. Shell scripts must be robust
  (`set -euo pipefail`).
- **Scripts home**: every executable script lives in `archlinux/.local/bin/`
  (already on `PATH`). Never create or reference `~/.config/*/scripts/` dirs;
  scripts that source UI colors use `~/.config/ui/ui.sh`, which exports only
  variables that have real consumers.
- **Quickshell layout**: `shell.qml`, `Theme.qml` (singleton) and
  `Notifications.qml` (singleton) sit at the root of `quickshell/`;
  surface views live in `views/` and reusable components in `widgets/`.
  Files outside the root import those singletons and shared types with
  `import ".."`. Keep it that way instead of re-flattening.
- **Quickshell status modules**: bar pills prefer native APIs — battery via
  `UPower.devices` (pick the laptop battery; `displayDevice` is broken on
  some machines and always reports 0%), network via `Quickshell.Networking`,
  sysfs/proc state via `FileView` + one shared poll `Timer` in `Bar.qml`.
  Do not reintroduce script-backed status modules (`ScriptModule.qml` was
  deleted).
- **Quickshell**: `Notification.image` is always directly loadable by
  `Image` (quickshell normalizes image-data/image-path hints) — pass it
  through verbatim; resolve bare app icon names with `Quickshell.iconPath`.
  Nested `Repeater` delegates receive the *outer* delegate's `modelData`, so
  delegates must declare `required property var modelData` to read their own
  entry. Singleton services (Notifications, Osd, Clipboard) own their
  operations as real root functions; `IpcHandler` blocks only delegate to
  them. Surfaces that need keyboard input must set
  `WlrLayershell.keyboardFocus` and handle Esc. `SystemClock` exposes the
  current time as `date` (there is no `time` property); `MouseArea` here has
  no `wheelEnabled` property, use an `onWheel` handler directly.
  `wpctl get-volume` prints a fraction (0.65), not percent.
- **Hyprland special workspaces**: never restyle `specialWorkspaceIn/Out`
  animations horizontally at runtime; the native special-workspace gesture
  finger-tracks the card between the current animation's begun/goal offsets,
  so only vertical slide styles keep swipe-down hiding correct.
