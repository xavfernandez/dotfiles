return {
	cmd = { "pyright-langserver", "--stdio" },
	root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt" },
	filetypes = { "python" },
	settings = {
		pyright = {
			-- Leave that to ruff.
			disableOrganizeImports = false,
		},
		python = {
			analysis = {
				autoImportCompletions = true,
				autoSearchPaths = true,
			},
		},
	},
}
