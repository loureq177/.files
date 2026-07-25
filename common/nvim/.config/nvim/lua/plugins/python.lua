-- lua/plugins/python.lua
return {
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
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				python = { "ruff_organize_imports", "ruff_format" },
			},
		},
	},
}
