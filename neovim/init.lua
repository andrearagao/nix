vim.g.mapleader = " "

vim.g.netrw_banner = 0 -- gets rid of the annoying banner for netrw
vim.g.netrw_browse_split = 4 -- open in prior window
vim.g.netrw_altv = 1 -- change from left splitting to right splitting
vim.g.netrw_liststyle = 3 -- tree style view in netrw
vim.opt.syntax = "ON"
vim.opt.termguicolors = true

vim.opt.ignorecase = true -- enable case insensitive searching
vim.opt.smartcase = true -- all searches are case insensitive unless there's a capital lette
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = false
vim.opt.autoindent = true
vim.opt.breakindent = true
vim.opt.copyindent = true
vim.opt.cursorline = true
vim.opt.preserveindent = true
vim.opt.fileencoding = "utf-8"
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.showmode = false

vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

vim.opt.title = false -- show title
vim.cmd("set path+=**") -- search current directory recursively

vim.opt.showtabline = 0 -- always show the tab line
vim.opt.laststatus = 2 -- always show statusline
vim.opt.signcolumn = "auto"
vim.opt.updatetime = 50
vim.opt.timeoutlen = 300

vim.opt.colorcolumn = "120"

vim.opt.fillchars = { eob = " " }

vim.o.listchars = "trail:-,nbsp:+,tab:▏ "
vim.opt.list = true -- Enable displaying of 'listchars'
-- those pesky avro schema files...
vim.cmd([[
  augroup AvroSchema
    autocmd!
    autocmd BufRead,BufNewFile *.avsc set filetype=json
  augroup END
]])

-- vim.o.laststatus = 3

vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0
-- neovide options
vim.o.guifont = "JetBrainsMono Nerd Font:style=Bold:h10"
--local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
--if not vim.loop.fs_stat(lazypath) then
--	vim.fn.system({
--		"git",
--		"clone",
--		"--filter=blob:none",
--		"https://github.com/folke/lazy.nvim.git",
--		"--branch=stable", -- latest stable release
--		lazypath,
--	})
--end
require("lazy").setup({
	-- Git related plugins
	"tpope/vim-fugitive",
	"tpope/vim-rhubarb",

	{ "nvim-lua/plenary.nvim" },
	{
		"dstein64/vim-startuptime",
		cmd = "StartupTime",
		config = function()
			vim.g.startuptime_tries = 10
		end,
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},
	{
		"folke/zen-mode.nvim",
		opts = {
			alacritty = {
				enabled = true,
				font = "14", -- font size
			},
			tmux = {
				enabled = false,
			},
		},
	},
	ConfigureTheme(),
	Telescope(),
	ConfigureMiniStarter(),
	Treesitter(),
	Animate(),
	Lsp(),
	Completion(),
	Illuminate(),
	IndentBlankLine(),
	Oil(),
	Trouble(),
	Persistence(),
	Statusline(),
	Notify(),
	Navic(),
	SymbolsOutline(),
	Dap(),
	{
		"sontungexpt/url-open",
		event = "VeryLazy",
		cmd = "URLOpenUnderCursor",
		config = function()
			local status_ok, url_open = pcall(require, "url-open")
			if not status_ok then
				return
			end
			url_open.setup({})
		end,
	},
	-- Nonels(),
	{ "MunifTanjim/nui.nvim", lazy = true },
	{
		"norcalli/nvim-colorizer.lua",
		lazy = false,
		opts = {
			user_default_options = {
				AARRGGBB = true,
			},
		},
	},
	{ "christoomey/vim-tmux-navigator", lazy = false },
	Noice(),
	Conform(),
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = function()
			require("lazy").load({ plugins = { "markdown-preview.nvim" } })
			vim.fn["mkdp#util#install"]()
		end,
		keys = {
			{
				"<leader>cp",
				ft = "markdown",
				"<cmd>MarkdownPreviewToggle<cr>",
				desc = "Markdown Preview",
			},
		},
		config = function()
			vim.cmd([[do FileType]])
		end,
	},
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	"folke/which-key.nvim",
	{
		"L3MON4D3/LuaSnip",
		build = (not jit.os:find("Windows"))
				and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
			or nil,
		dependencies = {
			"rafamadriz/friendly-snippets",
			config = function()
				require("luasnip.loaders.from_vscode").lazy_load()
			end,
		},
		opts = {
			history = true,
			delete_check_events = "TextChanged",
		},
		keys = {
			{
				"<tab>",
				function()
					return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
				end,
				expr = true,
				silent = true,
				mode = "i",
			},
			{
				"<tab>",
				function()
					require("luasnip").jump(1)
				end,
				mode = "s",
			},
			{
				"<s-tab>",
				function()
					require("luasnip").jump(-1)
				end,
				mode = { "i", "s" },
			},
		},
	},
})

vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
require("colorizer").setup()

local function augroup(name)
	return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = augroup("checktime"),
	command = "checktime",
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("highlight_yank"),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
	group = augroup("resize_splits"),
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup("last_loc"),
	callback = function(event)
		local exclude = { "gitcommit" }
		local buf = event.buf
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
			return
		end
		vim.b[buf].lazyvim_last_loc = true
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("close_with_q"),
	pattern = {
		"PlenaryTestPopup",
		"help",
		"lspinfo",
		"man",
		"notify",
		"qf",
		"query",
		"spectre_panel",
		"startuptime",
		"tsplayground",
		"neotest-output",
		"checkhealth",
		"neotest-summary",
		"neotest-output-panel",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("wrap_spell"),
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = augroup("auto_create_dir"),
	callback = function(event)
		if event.match:match("^%w%w+://") then
			return
		end
		local file = vim.loop.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})
