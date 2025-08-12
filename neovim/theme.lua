function ConfigureTheme()
	return {
		{
			"rose-pine/neovim",
			lazy = false,
			name = "rose-pine",
			priority = 1000,
			config = function()
				require("rose-pine").setup({
					bold_vert_split = false,
					dim_nc_background = false,
					disable_background = true,
					disable_float_background = true,
					disable_italics = false,
					highlight_groups = {
						Comment = { italic = true },
					},
				})
				vim.cmd([[colorscheme rose-pine ]])
			end,
		},
		{
			"catppuccin/nvim",
			lazy = false,
			name = "catppuccin",
			priority = 1000, -- make sure to load this before all the other start plugins
			config = function(_, opts)
				require("catppuccin").setup(opts)
				-- vim.cmd([[colorscheme catppuccin]])
			end,
			opts = {
				flavour = "mocha", -- latte, frappe, macchiato, mocha
				background = { -- :h background
					light = "latte",
					dark = "mocha",
				},
				transparent_background = true, -- disables setting the background color.
				show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
				term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
				dim_inactive = {
					enabled = true, -- dims the background color of inactive window
					shade = "dark",
					percentage = 0.15, -- percentage of the shade to apply to the inactive window
				},
				integrations = {
					aerial = true,
					alpha = true,
					cmp = true,
					dashboard = true,
					flash = true,
					gitsigns = true,
					headlines = true,
					illuminate = true,
					indent_blankline = { enabled = true },
					leap = true,
					lsp_trouble = true,
					mason = true,
					markdown = true,
					mini = true,
					native_lsp = {
						enabled = true,
						underlines = {
							errors = { "undercurl" },
							hints = { "undercurl" },
							warnings = { "undercurl" },
							information = { "undercurl" },
						},
					},
					navic = { enabled = true, custom_bg = "lualine" },
					neotest = true,
					neotree = true,
					noice = true,
					notify = true,
					semantic_tokens = true,
					telescope = true,
					treesitter = true,
					treesitter_context = true,
					which_key = true,
				},
			},
		},
	}
end
