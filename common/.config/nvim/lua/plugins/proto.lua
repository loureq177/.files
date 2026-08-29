return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				bufls = {},
			},
		},
	},

	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				proto = { "buf" },
			},
		},
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, { "proto" })
			end
		end,
	},
}
