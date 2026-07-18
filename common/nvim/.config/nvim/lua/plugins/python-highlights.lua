return {
  -- ponytail: pyright semantic tokens override treesitter with incomplete theme
  -- support => disable them, treesitter highlighting is cleaner.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          capabilities = {
            semanticTokens = false,
          },
        },
        basedpyright = {
          capabilities = {
            semanticTokens = false,
          },
        },
      },
    },
  },
}
