local mason_nvim = {
	"williamboman/mason.nvim",
}

mason_nvim.config = function()
	require("mason").setup()
end

return mason_nvim
