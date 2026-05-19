# OpenCode Agent Instructions

## Repository Structure & Management
- This is a dotfiles repository managed by **GNU Stow**.
- Top-level directories (e.g., `nvim`, `hypr`, `waybar`, `ghostty`) are Stow "packages".
- The internal structure of these packages mirrors the user's `$HOME` directory (e.g., `nvim/.config/nvim/...` is symlinked to `~/.config/nvim/...`).

## Applying Changes
- **CRITICAL:** Do not edit files directly in `~/.config/`. Always edit files within this repository.
- After modifying or adding files in a package, restow it to apply changes to the system:
  ```sh
  stow -R -t ~ <package_name>
  ```
- To restow all packages, use `stow -R -t ~ */`.
- Note that `.stowrc` contains default ignore rules so repo management files aren't symlinked.

## Frameworks & Tooling
- **Hyprland:** Uses the new standard **Lua** configuration format (`hypr/.config/hypr/hyprland.lua`). Do not look for or create traditional `.conf` files.
- **Neovim:** Built on **LazyVim**. Customizations belong in the standard LazyVim `lua/plugins/` and `lua/config/` structure.

## Design Goals
- The overriding goal for the Hyprland setup is to achieve a polished, Mac/GNOME-like UI/UX (e.g., centralized clocks, functional quick settings, elegant waybar modules). Ensure aesthetic consistency and functional parity with major desktop environments when adding features.
