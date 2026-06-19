vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "blink-cmp" and (kind == "update" or kind == "install") then
			if not ev.data.active then
				vim.cmd.packadd("blink-cmp")
			end
			vim.cmd("cargo build --release")
		end
	end,
})

vim.pack.add({
	-- fzf-lua
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/ibhagwan/fzf-lua",
	"https://github.com/tpope/vim-fugitive",
	"https://github.com/tpope/vim-rhubarb",
	"https://github.com/airblade/vim-gitgutter",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/craftzdog/solarized-osaka.nvim",
	"https://github.com/nvim-treesitter/nvim-treesitter-context",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/saghen/blink.cmp",

	-- For codecompanion
	"https://www.github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	{
		src = "https://www.github.com/olimorris/codecompanion.nvim",
		version = vim.version.range("^19.0.0"),
	},

	-- For blink.cmp
	"https://github.com/rafamadriz/friendly-snippets",
	{
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range("1.*"),
	},
})

vim.g.mapleader = ","

vim.g.python3_host_prog = "/usr/bin/python3"

vim.opt.compatible = false
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.matchpairs:append("<:>")
vim.opt.hidden = true
vim.opt.list = true
vim.opt.number = true
vim.opt.grepprg = "rg --hidden --vimgrep" -- Avoid --no-ignore default behavior

-- Searching and patterns
vim.opt.ignorecase = true -- Default to using case insensitive searches
vim.opt.smartcase = true -- unless uppercase letters are used in the regex
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.background = "dark"

require("blink.cmp").setup({
	-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
	-- 'super-tab' for mappings similar to vscode (tab to accept)
	-- 'enter' for enter to accept
	-- 'none' for no mappings
	--
	-- All presets have the following mappings:
	-- C-space: Open menu or open docs if already open
	-- C-n/C-p or Up/Down: Select next/previous item
	-- C-e: Hide menu
	-- C-k: Toggle signature help (if signature.enabled = true)
	--
	-- See :h blink-cmp-config-keymap for defining your own keymap
	keymap = { preset = "super-tab" },

	appearance = {
		-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
		-- Adjusts spacing to ensure icons are aligned
		nerd_font_variant = "mono",
	},

	-- (Default) Only show the documentation popup when manually triggered
	completion = { documentation = { auto_show = false } },

	-- Default list of enabled providers defined so that you can extend it
	-- elsewhere in your config, without redefining it, due to `opts_extend`
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
		per_filetype = {
			codecompanion = { "codecompanion" },
		},
	},

	-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
	-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
	-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
	--
	-- See the fuzzy documentation for more information
	fuzzy = { implementation = "prefer_rust_with_warning" },
})
require("codecompanion").setup({
	interactions = {
		chat = {
			adapter = "mistral_vibe",
		},
	},
})
require("conform").setup({
	formatters_by_ft = {
		htmldjango = { "djlint" },
		lua = { "stylua" },
		python = function(bufnr)
			if os.getenv("NO_FORMAT") then
				return {}
			elseif require("conform").get_formatter_info("ruff_format", bufnr).available then
				return { "ruff_fix", "ruff_format" }
			else
				return { "isort", "black" }
			end
		end,
		["*"] = { "trim_newlines", "trim_whitespace" },
	},
	format_on_save = {
		lsp_fallback = false,
		timeout_ms = 6000,
	},
})

require("treesitter-context").setup({
	mode = "topline",
})

vim.cmd("colorscheme solarized-osaka")

vim.keymap.set("n", "<c-p>", ":FzfLua git_files<cr>")
vim.keymap.set("n", "<Leader>b", ":FzfLua buffers<cr>")
vim.keymap.set("n", "<Leader>c", ":FzfLua diagnostics_document bufnr=-1<cr>")
vim.keymap.set("n", "<Leader>m", ":FzfLua oldfiles<cr>")
vim.keymap.set("n", "<Leader>q", ":FzfLua quickfix<cr>")
vim.keymap.set("n", "<Leader>Q", ":FzfLua quickfix_stack<cr>")
vim.keymap.set("n", "<Leader>/", ":nohlsearch<cr>") -- Hide matches
vim.keymap.set("n", "<Leader>S", ":%s/\\s\\+$//<cr>:let @/=''") -- Remove trailing whitespaces & empty search register

vim.keymap.set("n", "<leader>ev", ":edit ~/.config/nvim/init.lua<CR>", { noremap = true })
vim.keymap.set("n", "<leader>sv", ":luafile ~/.config/nvim/init.lua<CR>", { noremap = true })

vim.api.nvim_create_user_command("GrepQuickfix", "silent grep! <args> | copen 20", { nargs = "+" })
vim.keymap.set("n", "<Leader>r", ":GrepQuickfix ")

-- Sarch in templates directories in Django projects
vim.opt.path:append({ "*/templates" })

vim.filetype.add({
	pattern = {
		[".*/itou/templates/.*%.html"] = { "htmldjango", priority = 10 },
	},
})

-- LSP configuration
vim.lsp.config("*", {
	root_markers = { ".git" },
})
vim.lsp.enable("htmlls")
vim.lsp.enable("jsonls")
vim.lsp.enable("luals")
vim.lsp.enable("pyright")
vim.lsp.enable("ruff")
vim.lsp.enable("rust_analyzer")

vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { noremap = true, silent = true })

vim.diagnostic.config({ virtual_lines = true })
