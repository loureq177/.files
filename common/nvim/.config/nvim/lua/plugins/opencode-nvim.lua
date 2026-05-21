return {
	"nickjvandyke/opencode.nvim",
	version = "*",
	lazy = true,
	keys = {
		{ "<C-.>", mode = { "n", "t" } },
		{ "<C-oa>", mode = { "n", "x" } },
		{ "<C-ox>", mode = { "n", "x" } },
		{ "go", mode = { "n", "x" } },
		{ "goo" },
		{ "<S-C-u>" },
		{ "<S-C-d>" },
	},
	checker = {
		enabled = false,
	},
	config = function()
		vim.o.autoread = true

		local opencode_cmd = "opencode --port"
		local snacks_terminal_opts = {
			win = {
				position = "right",
				width = 0.37,
				enter = false,
				on_win = function(win)
					require("opencode.terminal").setup(win.win)
				end,
			},
		}

		vim.g.opencode_opts = {
			server = {
				start = function()
					require("snacks.terminal").open(opencode_cmd, snacks_terminal_opts)
				end,
				stop = function()
					require("snacks.terminal").get(opencode_cmd, snacks_terminal_opts):close()
				end,
				toggle = function()
					require("snacks.terminal").toggle(opencode_cmd, snacks_terminal_opts)
				end,
			},
			events = {
				permissions = {
					enabled = true,
					edits = { enabled = true },
				},
			},
		}

		vim.keymap.set({ "n", "x" }, "<C-oa>", function()
			require("opencode").ask("@this: ", { submit = true })
		end, { desc = "Ask opencode…" })
		vim.keymap.set({ "n", "x" }, "<C-ox>", function()
			require("opencode").select()
		end, { desc = "Execute opencode action…" })
		vim.keymap.set({ "n", "t" }, "<C-.>", function()
			require("opencode").toggle()
		end, { desc = "Toggle opencode" })
		vim.keymap.set({ "n", "x" }, "go", function()
			return require("opencode").operator("@this ")
		end, { desc = "Add range to opencode", expr = true })
		vim.keymap.set("n", "goo", function()
			return require("opencode").operator("@this ") .. "_"
		end, { desc = "Add line to opencode", expr = true })
		vim.keymap.set("n", "<S-C-u>", function()
			require("opencode").command("session.half.page.up")
		end, { desc = "Scroll opencode up" })
		vim.keymap.set("n", "<S-C-d>", function()
			require("opencode").command("session.half.page.down")
		end, { desc = "Scroll opencode down" })
	end,
}
