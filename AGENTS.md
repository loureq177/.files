# dotfiles

Dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Structure

- `common/` — OS-agnostic configs (bat, git, ghostty, neovim, opencode, starship, zsh, etc.)
- `archlinux/` — Arch-only configs (hypr, waybar, rofi, mako, systemd, etc.)

Each package mirrors the target directory structure. E.g. `common/ghostty/.config/ghostty/config` stows to `~/.config/ghostty/config`.

## Deploy

```sh
./install.sh   # chmod +x scripts, stow common/ + archlinux/, rebuild bat cache
```

Or per-package: `cd common && stow --restow --target ~ ghostty`

`.stowrc` ignores `.git`, `README.md`, `LICENSE`.

## Key scripts (in `common/bin/.local/bin/`)

| Script | What |
|---|---|
| `rclone_sync` | Google Drive backup via rclone |
| `sysupdate` | Full update: nvim plugins, zinit, bun, rustup, paru |
| `sysclean` | Remove orphans, clean pacman cache + `~/.cache` |
| `matlab` | MATLAB via Podman with NVIDIA passthrough |

## ZSH

- `ZDOTDIR` set to `~/.config/zsh` via `.zshenv`
- Plugin manager: zinit (zsh-completions, fzf-tab, autosuggestions, fast-syntax-highlighting)
- zoxide for `cd`, starship prompt
- Aliases: `ls`→`eza`, `cat`→`bat -pp`, `grep`→`rg`
- Auto-starts Hyprland if tty1 with no display

## Theme

TokyoNight Moon throughout (bat, btop, gtk, mako, rofi, waybar, git/delta).

## Opencode config

Permissions model + plugin + custom commands live in `common/opencode/.config/opencode/`. Built-in bash whitelist (`git`, `ls`, `rg`, `bat`, `paru`, etc.). Plugin uses `notify-send`.

## Git config

- Editor: nvim, pager: delta (TokyoNight, side-by-side)
- `autoSetupRemote = true`, default branch `main`
- GitHub auth via `gh` credential helper

## Neovim

LazyVim-based config in `common/nvim/`. Extras include black, prettier, php, python, typescript, sql, etc. Custom commands: `:CompareWithClipboard`.

## CI / lint / test

No CI, no test suite, no lint/typecheck runners. This is a static dotfiles repo — apply changes directly.

## Gotchas

- GDK and QT scale factors are set per-Hyprland-monitor in `hypr/monitors.lua`
- `$SSH_AUTH_SOCK` set to `$XDG_RUNTIME_DIR/ssh-agent.socket`
- Waybar style overrides use `.txt` file extension (loaded via `@import`)
- `.zcompdump`, `lazy-lock.json`, `todo.md` are gitignored
