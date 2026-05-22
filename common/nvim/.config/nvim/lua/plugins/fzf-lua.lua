return {
	{
		"ibhagwan/fzf-lua",
		opts = function(_, opts)
			opts.silent = true

			opts.files = opts.files or {}
			opts.files.fd_opts = "--color=never --type f --hidden --no-ignore --exclude .git"

			opts.grep = opts.grep or {}
			opts.grep.rg_opts =
				"--column --line-number --no-heading --color=always --smart-case --hidden --no-ignore -g '!.git/'"
		end,
	},
}

