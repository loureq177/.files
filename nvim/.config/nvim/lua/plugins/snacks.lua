return {
	"folke/snacks.nvim",
	opts = {
		explorer = {
			replace_netrw = true,
		},
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
				},
			},
		},
	},
}
