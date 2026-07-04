return {
	"stevearc/conform.nvim",
	opts = function(_, opts)
		opts.formatters_by_ft = opts.formatters_by_ft or {}
		opts.formatters_by_ft.php = { "php_cs_fixer" }

		opts.formatters = opts.formatters or {}
		opts.formatters.php_cs_fixer = {
			args = {
				"fix",
				"$FILENAME",
				"--rules=@PSR12",
				"--using-cache=no",
				"--no-interaction",
				"--allow-risky=yes",
			},
			env = {
				PHP_CS_FIXER_IGNORE_ENV = "1",
			},
		}

		opts.format_on_save = {
			timeout_ms = 1500,
			lsp_fallback = true,
		}
	end,
}
