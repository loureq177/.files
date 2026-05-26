# Agent Instructions

This repository contains personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/). 

## Architecture & Structure
- **GNU Stow:** Packages are symlinked to the home directory.
- **Categories:** Configs are split into `common/` (macOS/Linux shared) and `archlinux/` (OS-specific).
- **File Hierarchy:** Files within a package directory mimic the target home directory structure. For example, `~/.config/starship.toml` is stored at `common/starship/.config/starship.toml`.
- **Ignored Files:** `.stowrc` is configured to ignore `.git`, `README.md`, and `LICENSE` during symlinking.

## Editing Rules
- **DO NOT** edit symlinked files directly in `~` or `~/.config`.
- **ALWAYS** edit the source files located in `~/.files/common/` or `~/.files/archlinux/`.
- After adding new files or changing the structure of a package, re-run the Stow command to update the symlinks.

## Execution Commands
Use these commands to apply or update configurations:

```sh
# Apply or update a shared config
cd ~/.files/common && stow --restow --target ~ <package_name>

# Apply or update an Arch Linux config
cd ~/.files/archlinux && stow --restow --target ~ <package_name>
```

*(e.g., to update zsh: `cd ~/.files/common && stow --restow --target ~ zsh`)*
