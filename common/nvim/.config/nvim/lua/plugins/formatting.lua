return {
	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			opts.formatters_by_ft = opts.formatters_by_ft or {}
			opts.formatters_by_ft.php = { "php_cs_fixer" }
			opts.formatters_by_ft.markdown = { "prettier" }

			opts.formatters = opts.formatters or {}
			opts.formatters.php_cs_fixer = {
				args = {
					"fix",
					"$FILENAME",
					"--no-interaction",
				},
			}
		end,
	},
}
