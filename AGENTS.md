# .files — dotfiles

Managed with **GNU Stow**. Every `stow --restow --target ~` creates symlinks
from package dirs under this repo into `$HOME`. The `.stowrc` file skips `.git`,
`README.md`, and `LICENSE`.

## Layout

| Path              | Purpose                                                                                                 |
| ----------------- | ------------------------------------------------------------------------------------------------------- |
| `archlinux/`      | Hyprland, Waybar, Rofi, Mako, Ly, Wireplumber, systemd user units, PWAs, `~/.local/bin` scripts         |
| `common/`         | Neovim (LazyVim), Ghostty, Zsh, Starship, Git, Bat, Btop, Yazi, Prettier, SSH, XDG, MIME apps, Opencode |
| `speech-to-text/` | Faster-Whisper daemon (dictate) — Python venv in `.venv/`                                               |

## Commands

```bash
# Bootstrap (idempotent — safe to re-run)
./install.sh

# Add or update a package
cd common && stow --restow --target ~ <pkg>

# Remove a package symlinks
cd common && stow -D --target ~ <pkg>
```

## Opencode config

Custom commands live under `common/opencode/.config/opencode/commands/`:
`audit-repo`, `commit-gen`, `explain-architecture`, `optimize-code`,
`write-tests`. Permission rules in `opencode.json` whitelist common read-only
commands (`git *`, `ls *`, `rg *`, `fd *`, `bat *`, `tree *`, `paru -q *`,
`systemctl status *`, `journalctl *`) and allow edit with confirmation.

## Automation

- **`install.sh`** — OS-detecting bootstrap: stows archlinux → speech-to-text →
  common, rebuilds bat cache, enables user systemd services.
- **`archlinux/bin/.local/bin/`** — `sysupdate`, `sysclean`, `bedtime`,
  `rclone_sync`, `systemd-notify-{fail,success}`, PWA launchers.
- **`archlinux/systemd/`** — user services/timers for dictate-daemon, bedtime,
  rclone-sync.

## Git

- Default branch: `main`
- Remote: `git@github.com:loureq177/.files.git`
- Commit style: conventional prefixes (`zsh:`, `hypr:`, `waybar:`, `rofi:`,
  `common:`, `opencode:`, `install:`, etc.)
