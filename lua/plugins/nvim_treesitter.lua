local nvim_treesitter = {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	event = "VeryLazy",
}

nvim_treesitter.config = function()
	require("nvim-treesitter.configs").setup({
		ensure_installed = "all",
		sync_install = false,
		auto_install = true,
		highlight = {
			enable = true,
		},
		context_commentstring = {
			enable = true,
		},
	})

	local function link_comment()
		vim.api.nvim_set_hl(0, "@lsp.type.comment.c", { link = "Comment" })
		vim.api.nvim_set_hl(0, "@lsp.type.comment.cpp", { link = "Comment" })
	end

	-- Add the lsp comment highlights now, and again later if we change colorschemes.
	link_comment()
	vim.api.nvim_create_autocmd("ColorScheme", {
		callback = link_comment,
	})

	-- local links = {
	-- 	["@lsp.type.namespace"] = "@namespace",
	-- 	["@lsp.type.type"] = "@type",
	-- 	["@lsp.type.class"] = "@type",
	-- 	["@lsp.type.enum"] = "@type",
	-- 	["@lsp.type.interface"] = "@type",
	-- 	["@lsp.type.struct"] = "@structure",
	-- 	["@lsp.type.parameter"] = "@parameter",
	-- 	["@lsp.type.variable"] = "@variable",
	-- 	["@lsp.type.property"] = "@property",
	-- 	["@lsp.type.enumMember"] = "@constant",
	-- 	["@lsp.type.function"] = "@function",
	-- 	["@lsp.type.method"] = "@method",
	-- 	["@lsp.type.macro"] = "@macro",
	-- 	["@lsp.type.decorator"] = "@function",
	-- }
	-- for newgroup, oldgroup in pairs(links) do
	-- 	vim.api.nvim_set_hl(0, newgroup, { link = oldgroup, default = true })
	-- end
end

return nvim_treesitter
