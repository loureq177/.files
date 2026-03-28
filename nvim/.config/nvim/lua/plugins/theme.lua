return {
	-- 1. Konfiguracja wtyczki Catppuccin
	{
		"catppuccin/nvim",
		name = "catppuccin",
		opts = {
			flavour = "mocha",
			transparent_background = true,
			integrations = {
				treesitter = true,
				native_lsp = {
					enabled = true,
				},
				telescope = {
					enabled = true,
				},
				neotree = true,
				lualine = true,
			},
		},
	},

	-- 2. Ustawienie Catppuccin jako domyślnego motywu w LazyVim
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "catppuccin",
		},
	},
}
