local mason_nvim = {
	"williamboman/mason.nvim",
	event = "VeryLazy",
}

mason_nvim.config = function()
	require("mason").setup()
end

return mason_nvim
