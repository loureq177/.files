vim.api.nvim_create_autocmd("User", {
	pattern = "SnacksDashboardOpened",
	once = true,
	callback = function()
		require("config.matrix_intro").play()
	end,
})

-- Not on the first screen: each attaches, as it loads, to the buffers already open.
local function after_first_screen(name)
	return {
		name,
		event = function()
			return { "VeryLazy" }
		end,
	}
end

return {
	after_first_screen("lewis6991/gitsigns.nvim"),
	after_first_screen("gbprod/yanky.nvim"),
	after_first_screen("folke/todo-comments.nvim"),
	after_first_screen("nvim-mini/mini.hipatterns"),
	after_first_screen("stevearc/aerial.nvim"),
	after_first_screen("windwp/nvim-ts-autotag"),

	{
		"projekt0n/github-nvim-theme",
		name = "github-theme",
		lazy = false,
		priority = 1000,
		config = function()
			require("github-theme").setup({ options = { transparent = true } })
		end,
	},

	{ "folke/flash.nvim", enabled = false },

	{
		"stevearc/aerial.nvim",
		opts = {
			on_attach = function(bufnr)
				vim.keymap.set(
					"n",
					"{",
					"<cmd>AerialPrev<CR>",
					{ buffer = bufnr, desc = "Aerial Previous Symbol" }
				)
				vim.keymap.set(
					"n",
					"}",
					"<cmd>AerialNext<CR>",
					{ buffer = bufnr, desc = "Aerial Next Symbol" }
				)
			end,
		},
		keys = {
			{ "<leader>cs", "<cmd>AerialToggle!<CR>", desc = "Aerial (Symbols Outline)" },
		},
	},

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

	{
		"neovim/nvim-lspconfig",
		-- A file nvim opens with is drawn first: mason's registry and the servers' setup (~27 ms)
		-- come with VeryLazy, and vim.lsp.enable attaches the servers to the buffers already open.
		event = function()
			return {}
		end,
		init = function()
			vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
				once = true,
				callback = function()
					local function load()
						require("lazy").load({ plugins = { "nvim-lspconfig" } })
					end
					if vim.g.did_very_lazy then
						load()
					else
						vim.api.nvim_create_autocmd("User", { pattern = "VeryLazy", once = true, callback = load })
					end
				end,
			})
		end,
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

	{
		"lervag/vimtex",
		lazy = true,
		ft = { "tex", "bib", "cls", "sty" },
	},

	{
		"folke/snacks.nvim",
		opts = {
			terminal = { win = { wo = { winbar = "" } } },
			explorer = { replace_netrw = true },
			picker = {
				hidden = true,
				ignored = false,
				sources = {
					explorer = {
						layout = { layout = { position = "right", width = 30 } },
					},
					files = {
						hidden = true,
					},
				},
			},
			dashboard = {
				enabled = true,
				preset = {
					header = table.concat(require("config.matrix_intro").logo, "\n"),
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
