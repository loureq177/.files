# .files

My terminal setup for Arch Linux and macOS, linked into `~` with [GNU Stow](https://www.gnu.org/software/stow/).

## What's inside

- **zsh**: zinit, fzf-tab, autosuggestions, syntax highlighting, starship, zoxide, eza
- **Neovim**: LazyVim
- **Ghostty**, **yazi**, **btop**, **bat**, **lazygit**, **git** with delta, all in GitHub Dark
- **opencode**: commands and theme
- **Firefox**: privacy defaults (`firefox-apply`)
- **Brewfile** for macOS

## Install

```sh
git clone https://github.com/loureq177/.files.git ~/.files
~/.files/install.sh
```

On macOS this installs Homebrew and the Brewfile first. Machine-local files (`~/.config/git/config.local`, `~/.config/zsh/.zshrc.local`, `~/.ssh/config`) stay out of git; each has an `.example`.

The Hyprland desktop that goes with it on Arch is [desktop](https://github.com/loureq177/desktop).
