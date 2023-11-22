local nvim_treesitter = {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	dependencies = {
		"p00f/nvim-ts-rainbow",
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

		rainbow = {
			enable = true,
			-- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
			extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
			max_file_lines = nil, -- Do not enable for files with more than n lines, int
			-- colors = {}, -- table of hex strings
			-- termcolors = {} -- table of colour name strings
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
end

return nvim_treesitter
