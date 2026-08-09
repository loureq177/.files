vim.api.nvim_create_autocmd("User", {
	pattern = "SnacksDashboardOpened",
	once = true,
	callback = function()
		require("config.matrix_intro").play()
	end,
})

return {
	-- Theme
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

	-- Disabled plugins
	{ "folke/flash.nvim", enabled = false },

	-- Aerial (Symbols Outline)
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

	-- Formatting (Conform)
	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			opts.formatters_by_ft = opts.formatters_by_ft or {}
			opts.formatters_by_ft.php = { "php_cs_fixer" }
			opts.formatters_by_ft.markdown = { "prettier" }
			opts.formatters_by_ft.python = { "ruff_organize_imports", "ruff_format" }

			opts.formatters = opts.formatters or {}
			opts.formatters.php_cs_fixer = {
				stdin = false,
				args = {
					"fix",
					"$FILENAME",
					"--no-interaction",
				},
			}
			return opts
		end,
	},

	-- Python / LSP
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				pyrefly = {},
				ruff = {
					on_attach = function(client, _)
						client.server_capabilities.diagnosticProvider = false
						client.handlers["textDocument/publishDiagnostics"] = function() end
						client.server_capabilities.hoverProvider = false
					end,
				},
			},
		},
	},

	-- Vimtex
	{
		"lervag/vimtex",
		lazy = true,
		ft = { "tex", "bib", "cls", "sty" },
	},

	-- Snacks
	{
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
	},
}
