# .files

My terminal setup for Arch Linux and macOS, linked into `~` with [GNU Stow](https://www.gnu.org/software/stow/).

## What's inside

- **zsh**: zinit, fzf-tab, autosuggestions, syntax highlighting, starship, zoxide, eza
- **Neovim**: LazyVim
- **Ghostty**, **yazi**, **btop**, **bat**, **lazygit**, **git** with delta, all in GitHub Dark
- **opencode**: commands and theme
- **Claude Code**: language servers as plugins, so edits come back with the errors: Pyrefly, TypeScript, Intelephense, Lua and on Arch QML (`claude-plugins/` holds the two the official marketplace lacks)
- **Firefox**: privacy defaults (`firefox-apply`)
- **Brewfile** for macOS, **packages-arch.txt** for Arch
- **kanata**, one config for macOS and Arch (`~/.config/kanata/kanata.kbd`): Caps Lock is Escape tapped and Control held; Tab held makes hjkl the arrows, and then types no Tab. On Arch FreshArchLinux runs it. On macOS it is pinned, as its driver must match: once by hand, the [Karabiner VirtualHIDDevice driver](https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/releases/tag/v6.2.0) v6.2.0 (kanata 1.12; 1.13 needs v8.0.0), then its [setup](https://github.com/jtroo/kanata/blob/main/docs/setup-macos.md): `forceActivate`, the driver's daemon as a LaunchDaemon, Input Monitoring and Accessibility for kanata, and `sudo brew services start kanata`

## Install

```sh
git clone https://github.com/loureq177/.files.git ~/.files
~/.files/install.sh
```

It installs the programs first: Homebrew and the Brewfile on macOS, `packages-arch.txt` with pacman on Arch (and makes zsh the login shell there). Machine-local files (`~/.config/git/config.local`, `~/.config/zsh/.zshrc.local`, `~/.ssh/config`, `~/.config/ghostty/config.local`) stay out of git; all but Ghostty's have an `.example`.

The Hyprland desktop that goes with it on Arch is [desktop](https://github.com/loureq177/desktop).
