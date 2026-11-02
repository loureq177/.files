vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])
-- A letter deleted is no copy: it would replace the clipboard and fill its history.
vim.keymap.set("n", "x", [["_x]])
vim.keymap.set("n", "X", [["_X]])
vim.keymap.set("n", "<Del>", [["_x]])

vim.schedule(function()
	require("config.diff_clipboard")
end)
