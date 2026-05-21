return {
  {
    "ibhagwan/fzf-lua",
    opts = function(_, opts)
      opts.files = opts.files or {}
      opts.files.fd_opts = "--color=never --type f --hidden --no-ignore --exclude .git"

      opts.grep = opts.grep or {}
      opts.grep.rg_opts = (opts.grep.rg_opts or "") .. " --hidden --no-ignore -g '!.git/'"
    end,
  },
}