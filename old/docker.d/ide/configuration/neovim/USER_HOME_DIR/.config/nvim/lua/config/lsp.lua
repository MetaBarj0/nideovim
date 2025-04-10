require("mason-lspconfig").setup()
require("lspconfig").clangd.setup({})

require("lspconfig").denols.setup({
	init_options = {
		lint = true,
		unstable = true,
	},
	root_dir = require("lspconfig").util.root_pattern(
		"package.json",
		"deno.json",
		"deno.jsonc",
		".deno.json",
		".deno.jsonc"
	),
})

require("conform").setup({
	formatters_by_ft = {
		solidity = { "solidity_forge" },
	},
	formatters = {
		solidity_forge = {
			stdin = false,
			command = "forge",
			args = { "fmt" },
			cwd = require("conform.util").root_file({ "foundry.toml" }),
			require_cwd = true,
		},
	},
})
