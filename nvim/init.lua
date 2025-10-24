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

-- /home/xafer/.local/share/nvim/lazy/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	"tpope/vim-fugitive",
	"tpope/vim-rhubarb",
	"github/copilot.vim",
	"airblade/vim-gitgutter",
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"stevearc/conform.nvim",
		opts = {
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
		},
	},
	{
		"craftzdog/solarized-osaka.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},
	"nvim-treesitter/nvim-treesitter",
	{
		"nvim-treesitter/nvim-treesitter-context",
		opts = {
			mode = "topline",
		},
	},
	"nvim-treesitter/nvim-treesitter-textobjects",
	-- "neovim/nvim-lspconfig",
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

require("nvim-treesitter.configs").setup({
	ensure_installed = { "c", "css", "javascript", "html", "htmldjango", "python" },
	auto_install = true,

	highlight = {
		enable = true,
	},
})

vim.diagnostic.config({ virtual_lines = true })
