vim.api.nvim_create_autocmd("User", {
	pattern = "SnacksDashboardOpened",
	once = true,
	callback = function()
		require("config.matrix_intro").play()
	end,
})

return {
	"folke/snacks.nvim",
	---@type snacks.Config
	opts = {
		terminal = { win = { wo = { winbar = "" } } },
		explorer = { replace_netrw = true },
		picker = {
			hidden = true,
			ignored = false,
			sources = {
				explorer = {
					layout = { layout = { position = "right", width = 32 } },
				},
			},
		},
		dashboard = {
			enabled = true,
			preset = {
				header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
			},
			sections = {
				{ section = "header" },
				{ section = "keys", gap = 1, padding = 1 },
				{ section = "startup" },
			},
		},
	},
}
