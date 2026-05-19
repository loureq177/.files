-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "text" },
	callback = function()
		vim.opt_local.spell = true
		vim.opt_local.spelllang = { "en", "pl" }
		vim.opt_local.textwidth = 75
		vim.opt_local.formatoptions:add("t")
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
	end,
})

vim.api.nvim_create_user_command("DiffClipboard", function()
	local ftype = vim.bo.filetype
	vim.cmd("vsplit | enew")
	vim.bo.filetype = ftype
	vim.bo.buftype = "nofile"
	vim.cmd('normal! "+P')
	vim.cmd("windo diffthis")
end, {})
