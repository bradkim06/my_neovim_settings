local comment_nvim = {
	"numToStr/Comment.nvim",
	event = "BufRead",
}

comment_nvim.config = function()
	vim.g.skip_ts_context_commentstring_module = true
	require("Comment").setup({
		pre_hook = function()
			return vim.bo.commentstring
		end,
	})
end

return comment_nvim
