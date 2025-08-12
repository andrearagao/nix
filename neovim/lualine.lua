Icons = {
	misc = {
		dots = "󰇘",
	},
	dap = {
		Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
		Breakpoint = " ",
		BreakpointCondition = " ",
		BreakpointRejected = { " ", "DiagnosticError" },
		LogPoint = ".>",
	},
	diagnostics = {
		Error = " ",
		Warn = " ",
		Hint = " ",
		Info = " ",
	},
	git = {
		added = " ",
		modified = " ",
		removed = " ",
	},
	kinds = {
		Array = " ",
		Boolean = "󰨙 ",
		Class = " ",
		Codeium = "󰘦 ",
		Color = " ",
		Control = " ",
		Collapsed = " ",
		Constant = "󰏿 ",
		Constructor = " ",
		Copilot = " ",
		Enum = " ",
		EnumMember = " ",
		Event = " ",
		Field = " ",
		File = " ",
		Folder = " ",
		Function = "󰊕 ",
		Interface = " ",
		Key = " ",
		Keyword = " ",
		Method = "󰊕 ",
		Module = " ",
		Namespace = "󰦮 ",
		Null = " ",
		Number = "󰎠 ",
		Object = " ",
		Operator = " ",
		Package = " ",
		Property = " ",
		Reference = " ",
		Snippet = " ",
		String = " ",
		Struct = "󰆼 ",
		TabNine = "󰏚 ",
		Text = " ",
		TypeParameter = " ",
		Unit = " ",
		Value = " ",
		Variable = "󰀫 ",
	},
}

function Statusline()
	return {
		{
			"nvim-lualine/lualine.nvim",
			event = "VeryLazy",
			init = function()
				vim.g.lualine_laststatus = vim.o.laststatus
				if vim.fn.argc(-1) > 0 then
					-- set an empty statusline till lualine loads
					vim.o.statusline = " "
				else
					-- hide the statusline on the starter page
					vim.o.laststatus = 0
				end
			end,
			opts = function()
				-- PERF: we don't need this lualine require madness 🤷
				local lualine_require = require("lualine_require")
				lualine_require.require = require

				local icons = Icons

				vim.o.laststatus = vim.g.lualine_laststatus

				return {
					winbar = {
						lualine_a = { "navic" },
						lualine_b = {},
						lualine_c = {},
						lualine_x = {},
						lualine_y = {},
						lualine_z = {},
					},
					options = {
						-- theme = "palenight",
						theme = "auto",
						globalstatus = true,
						--component_separators = { left = '│', right = '│' },
						--
						component_separators = { left = "", right = "" },
						section_separators = { left = "", right = "" },
						disabled_filetypes = {
							"Starter",
							"starter",
							"toggleterm",
							"trouble",
							"Trouble",
							statusline = { "dashboard", "starter", "term" },
							winbar = { "starter", "term", "trouble", "Trouble" },
							tabline = { "starter", "term", "trouble", "Trouble", "Starter" },
						},
						disabled_buftypes = {
							"quickfix",
							"prompt",
							"Starter",
							"starter",
						},
						ignore_focus = {
							"Telescope",
							"quickfix",
							"trouble",
						},
					},
					sections = {
						lualine_a = { "mode" },
						lualine_b = { "branch" },

						lualine_c = {
							{
								"diagnostics",
								always_visible = true,
								symbols = {
									error = icons.diagnostics.Error,
									warn = icons.diagnostics.Warn,
									info = icons.diagnostics.Info,
									hint = icons.diagnostics.Hint,
								},
							},
							{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
							{
								"filename",
								file_status = true,
								newfile_status = true,
								path = 1,
							},
						},
						lualine_x = {
              -- stylua: ignore
              {
                function() return require("noice").api.status.command.get() end,
                cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
                --color = Util.ui.fg("Statement"),
              },
              -- stylua: ignore
              {
                function() return require("noice").api.status.mode.get() end,
                cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
                --color = Util.ui.fg("Constant"),
              },
              -- stylua: ignore
              {
                function() return "  " .. require("dap").status() end,
                cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
                --color = Util.ui.fg("Debug"),
              },
							{
								require("lazy.status").updates,
								cond = require("lazy.status").has_updates,
								--color = Util.ui.fg("Special"),
							},
							{
								"diff",
								symbols = {
									added = icons.git.added,
									modified = icons.git.modified,
									removed = icons.git.removed,
								},
								source = function()
									local gitsigns = vim.b.gitsigns_status_dict
									if gitsigns then
										return {
											added = gitsigns.added,
											modified = gitsigns.changed,
											removed = gitsigns.removed,
										}
									end
								end,
							},
						},
						lualine_y = {
							{ "encoding" },
							{
								"fileformat",
								symbols = {
									unix = "", -- e712
									dos = "", -- e70f
									mac = "", -- e711
								},
							},
						},
						lualine_z = {
							{ "progress", separator = " ", padding = { left = 1, right = 0 } },
							{ "location", padding = { left = 0, right = 1 } },
						},
					},
					extensions = { "lazy", "trouble", "symbols-outline", "quickfix", "fugitive" },
				}
			end,
		},
	}
end
