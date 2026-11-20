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

vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	once = true,
	callback = function()
		require("config.image_size").setup()
	end,
})

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
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose", "DiffviewRefresh" },
		keys = {
			{ "<leader>gv", "<cmd>DiffviewOpen<CR>", desc = "Diffview (Working Tree)" },
			{ "<leader>gV", "<cmd>DiffviewFileHistory<CR>", desc = "Diffview (Repo History)" },
		},
		opts = function()
			local close = { "n", "q", "<cmd>DiffviewClose<CR>", { desc = "Close Diffview" } }
			return {
				-- Lines only the old side has are red there, not green as "added".
				enhanced_diff_hl = true,
				keymaps = {
					view = { close },
					file_panel = { close },
					file_history_panel = { close },
				},
			}
		end,
		config = function(_, opts)
			require("diffview").setup(opts)

			-- The theme gives the diff groups a foreground, which paints a changed line one colour
			-- over its syntax. Backgrounds only, as in VSCode: the code keeps its highlighting.
			local function diff_highlights()
				local function bg(group)
					return vim.api.nvim_get_hl(0, { name = group, link = false }).bg
				end
				for _, group in ipairs({ "DiffAdd", "DiffChange" }) do
					vim.api.nvim_set_hl(0, group, { bg = bg(group) })
				end
				vim.api.nvim_set_hl(0, "DiffText", { bg = "#4a3f1a" })
				vim.api.nvim_set_hl(0, "DiffviewDiffAddAsDelete", { bg = bg("DiffDelete") })
			end
			diff_highlights()
			vim.api.nvim_create_autocmd("ColorScheme", { callback = diff_highlights })
		end,
	},

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
		"HakonHarnes/img-clip.nvim",
		event = "VeryLazy",
		opts = {
			default = {
				dir_path = "assets",
				relative_to_current_file = true,
				file_name = "%Y-%m-%d-%H-%M-%S",
				prompt_for_file_name = false,
				use_absolute_path = false,
				drag_and_drop = { enabled = true, insert_mode = true },
			},
		},
		keys = {
			{ "<leader>ip", "<cmd>PasteImage<CR>", desc = "Paste Image from Clipboard" },
		},
	},

	{
		"folke/snacks.nvim",
		opts = {
			image = { enabled = true },
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
