vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "text" },
	callback = function()
		vim.opt_local.spell = false
	end,
})

-- A paragraph is one line, as Overleaf writes it: wrapped at words, not run off the screen.
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "tex", "plaintex", "typst", "rst" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.breakindent = true
	end,
})

-- texlab's hints ("Unused label") stay in the sign column, not between the lines being read.
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client.name == "texlab" then
			local vt = vim.diagnostic.config().virtual_text
			vt = vim.tbl_extend("force", type(vt) == "table" and vt or {}, { severity = { min = vim.diagnostic.severity.WARN } })
			vim.diagnostic.config({ virtual_text = vt }, vim.lsp.diagnostic.get_namespace(client.id))
		end
	end,
})
