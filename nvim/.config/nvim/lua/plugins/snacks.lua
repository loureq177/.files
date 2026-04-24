return {
	"folke/snacks.nvim",
	opts = {
		terminal = {
			win = {
				wo = {
					winbar = "",
				},
			},
		},
		explorer = { replace_netrw = true },
		picker = {
			icons = {
				tree = {
					vertical = "│  ",
					middle = "├╴ ",
					last = "└╴ ",
				},
			},
			sources = {
				explorer = {
					hidden = true,
					ignored = true,
					layout = { layout = { position = "right" } },
				},
			},
		},
	},
}
