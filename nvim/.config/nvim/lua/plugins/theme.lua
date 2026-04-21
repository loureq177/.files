return {
	{
		"folke/tokyonight.nvim",
		name = "tokyonight",
		lazy = false,
		priority = 1000,
		opts = {
			style = "moon",
			-- transparent = true,
		},
	},

	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "tokyonight",
		},
	},
}
