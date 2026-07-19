return {
	{
		"folke/tokyonight.nvim",
		opts = {
			style = "night",
		},
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = true,
		opts = {
			flavour = "mocha",
		},
	},
	{
		"Mofiqul/vscode.nvim",
		lazy = true,
	},
	{
		"projekt0n/github-nvim-theme",
		name = "github-theme",
		lazy = false,
		priority = 1000,
		config = function()
			require("github-theme").setup()
			vim.cmd.colorscheme("github_dark_default")
		end,
	},
}
