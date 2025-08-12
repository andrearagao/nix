function Nonels()
	return {
		{
			"nvimtools/none-ls.nvim",
			opts = function(_, opts)
				local nls = require("null-ls")
				opts.sources = vim.list_extend(opts.sources or {}, {
					nls.builtins.code_actions.gomodifytags,
					nls.builtins.code_actions.impl,
					nls.builtins.formatting.goimports,
					nls.builtins.formatting.gofumpt,
					nls.builtins.diagnostics.hadolint,
					nls.builtins.diagnostics.markdownlint,
				})
			end,
		},
	}
end
