local M = {}

M.compare_with_clipboard = function()
	local ft = vim.bo.filetype or ""

	vim.cmd("vsplit")
	vim.cmd("enew")

	local clipboard = vim.fn.getreg("+")
	if clipboard == "" then
		vim.notify("Clipboard is empty!", vim.log.levels.WARN)
		vim.cmd("close")
		return
	end

	vim.api.nvim_put(vim.split(clipboard, "\n", { plain = true }), "l", false, true)

	vim.bo.buftype = "nofile"
	vim.bo.bufhidden = "wipe"
	vim.bo.swapfile = false
	vim.bo.filetype = ft

	vim.cmd("diffthis")
	vim.cmd("wincmd p")
	vim.cmd("diffthis")

	vim.keymap.set("n", "q", "<cmd>diffoff!<CR><cmd>close<CR>", {
		buffer = true,
		silent = true,
		desc = "Close diff view",
	})

	vim.notify("Diff with clipboard is shown. (q = exit)", vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("CompareWithClipboard", M.compare_with_clipboard, {
	desc = "Compare current buffer with clipboard",
	nargs = 0,
})

return M
