return {
	{
		"stevearc/aerial.nvim",
		opts = {
			on_attach = function(bufnr)
				vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr, desc = "Aerial Previous Symbol" })
				vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr, desc = "Aerial Next Symbol" })
			end,
		},
		keys = {
			{ "<leader>cs", "<cmd>AerialToggle!<CR>", desc = "Aerial (Symbols Outline)" },
		},
	},
}
