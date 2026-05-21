-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Quit with Ctrl+q
vim.keymap.set({ "i", "x", "n", "s" }, "<C-q>", "<cmd>qa<cr>", { desc = "Quit all" })

