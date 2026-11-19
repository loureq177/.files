# .files

My terminal setup for Arch Linux and macOS, linked into `~` with [GNU Stow](https://www.gnu.org/software/stow/).

## What's inside

- **zsh**: zinit, fzf-tab, autosuggestions, syntax highlighting, starship, zoxide, eza
- **Neovim**: LazyVim
- **Ghostty**, **yazi**, **btop**, **bat**, **lazygit**, **git** with delta, all in GitHub Dark
- **Claude Code**: language servers as plugins, so edits come back with the errors: Pyrefly, TypeScript, Intelephense, Lua and on Arch QML (`claude-plugins/` holds the two the official marketplace lacks)
- **Firefox**: privacy defaults (`firefox-apply`)
- **macOS**: pointer and scroll speeds, fast key repeat, calendar alerts that stay until closed (`macos-defaults`)
- **Brewfile** for macOS, **packages-arch.txt** for Arch
- **kanata**, one `kanata.kbd` for macOS and Arch: Caps Lock is Escape tapped and Control held, and held it makes hjkl the arrows (with Alt or Super on Linux they stay Control + hjkl, for resizing windows). On Arch FreshArchLinux runs it. On macOS kanata comes from brew, pinned, and `install.sh` adds the Karabiner driver its version needs (brew has no cask for it alone; checksum and Apple notarization checked), both raised together there and started at boot; once by hand, macOS asks to turn on the driver (Driver Extensions) and kanata (Input Monitoring). Left Control+Space+Escape stops kanata until the next boot

## Install

```sh
git clone https://github.com/loureq177/.files.git ~/.files
~/.files/install.sh
```

It installs the programs first: Homebrew and the Brewfile on macOS, `packages-arch.txt` with pacman on Arch (and makes zsh the login shell there). Machine-local files (`~/.config/git/config.local`, `~/.config/zsh/.zshrc.local`, `~/.ssh/config`, `~/.config/ghostty/config.local`) stay out of git; all but Ghostty's have an `.example`.

The Hyprland desktop that goes with it on Arch is [desktop](https://github.com/loureq177/desktop).
