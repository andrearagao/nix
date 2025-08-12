function Completion()
--	local border_opts = {
--		border = "single",
--		winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
--	}

	return {
		{
			"hrsh7th/nvim-cmp",
			version = false, -- last release is way too old
			event = "InsertEnter",
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"saadparwaiz1/cmp_luasnip",
			},
			opts = function()
				vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
				local cmp = require("cmp")
				local defaults = require("cmp.config.default")()
				return {
					completion = {
						completeopt = "menu,menuone,noinsert",
					},
					snippet = {
						expand = function(args)
							require("luasnip").lsp_expand(args.body)
						end,
					},
					mapping = cmp.mapping.preset.insert({
						["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
						["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
						["<C-b>"] = cmp.mapping.scroll_docs(-4),
						["<C-f>"] = cmp.mapping.scroll_docs(4),
						["<C-Space>"] = cmp.mapping.complete(),
						["<C-e>"] = cmp.mapping.abort(),
						["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
						["<S-CR>"] = cmp.mapping.confirm({
							behavior = cmp.ConfirmBehavior.Replace,
							select = true,
						}), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
						["<C-CR>"] = function(fallback)
							cmp.abort()
							fallback()
						end,
					}),
					sources = cmp.config.sources({
						{ name = "nvim_lsp", priority = 1000 },
						{ name = "nvim_lua", priority = 800 },
						{ name = "luasnip", priority = 750 },
						{ name = "buffer", priority = 500 },
						{ name = "path", priority = 250 },
						{ name = "command", priority = 100 },
					}, {
						{ name = "buffer" },
					}),

					--window = {

					--	completion = cmp.config.window.bordered(border_opts),
					--	documentation = cmp.config.window.bordered(border_opts),
					-- },
					duplicates = {
						nvim_lsp = 1,
						luasnip = 1,
						cmp_tabnine = 1,
						buffer = 1,
						path = 1,
					},
					formatting = {
						format = function(_, item)
							local icons = {
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
							}

							if icons[item.kind] then
								item.kind = icons[item.kind] .. item.kind
							end
							return item
						end,
					},
					experimental = {
						ghost_text = {
							hl_group = "CmpGhostText",
						},
					},
					sorting = defaults.sorting,
				}
			end,
			config = function(_, opts)
				for _, source in ipairs(opts.sources) do
					source.group_index = source.group_index or 1
				end
				require("cmp").setup(opts)
			end,
		},
		{
			"echasnovski/mini.pairs",
			event = "VeryLazy",
			opts = {},
		},
	}
end
