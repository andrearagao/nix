function Conform()
	return {
		{
			"stevearc/conform.nvim",
			optional = false,
			opts = {
				formatters_by_ft = {
					nix = { "alejandra" },
					lua = { "stylua" },
					sh = { "shfmt" },
					fish = { "fish_indent" },
					-- Conform will run multiple formatters sequentially
					python = { "isort", "black" },
					-- Use a sub-list to run only the first available formatter
					javascript = { { "prettierd", "prettier" } },
					go = { "goimports", "gofumpt" },
					["*"] = { "codespell" },
					["_"] = { "trim_whitespace" },
				},
				format_on_save = {
					-- These options will be passed to conform.format()
					timeout_ms = 500,
					lsp_fallback = true,
				},
				format_after_save = {
					lsp_fallback = true,
				},
				notify_on_error = true,
			},
		},
	}
end
