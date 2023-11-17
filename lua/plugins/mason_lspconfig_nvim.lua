local mason_lspconfig_nvim = {
	"williamboman/mason-lspconfig.nvim",
	dependencies = "williamboman/mason.nvim",
}

mason_lspconfig_nvim.config = function()
	require("mason").setup()
	require("mason-lspconfig").setup({})
end

return mason_lspconfig_nvim
