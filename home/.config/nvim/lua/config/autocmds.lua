vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "text" },
	callback = function()
		vim.opt_local.spell = false
		vim.opt_local.textwidth = 0
		vim.opt_local.formatoptions:remove("t")
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
	end,
})
