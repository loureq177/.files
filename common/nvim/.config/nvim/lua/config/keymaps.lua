-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Quit with Ctrl+q
vim.keymap.set({ "i", "x", "n", "s" }, "<C-q>", "<cmd>qa<cr>", { desc = "Quit all" })

-- Yanks (copies) to system clipboard using <leader>y
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })

-- Changes and deletes (cuts) without replacing system clipboard contents
vim.keymap.set({ "n", "v" }, "d", '"_d', { desc = "Delete to black hole register" })
vim.keymap.set({ "n", "v" }, "D", '"_D', { desc = "Delete to end of line (black hole)" })
vim.keymap.set({ "n", "v" }, "c", '"_c', { desc = "Change to black hole register" })
vim.keymap.set({ "n", "v" }, "C", '"_C', { desc = "Change to end of line (black hole)" })

-- Optional: If you still want to "cut" to the system clipboard, explicitly use another key combo
vim.keymap.set({ "n", "v" }, "<leader>d", '"+d', { desc = "Delete to system clipboard" })
