require("mason-lspconfig").setup()
require("lspconfig").clangd.setup({})
require("lspconfig").biome.setup({})

require("conform").setup({
	formatters_by_ft = {
		solidity = { "solidity_forge" },
		json = { "biome" },
		jsonc = { "biome" },
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
