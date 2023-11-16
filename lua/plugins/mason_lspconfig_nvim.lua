local mason_lspconfig_nvim = {
	"williamboman/mason-lspconfig.nvim",
	event = "VeryLazy",
}

mason_lspconfig_nvim.config = function()
	require("mason-lspconfig").setup()
end

return mason_lspconfig_nvim
