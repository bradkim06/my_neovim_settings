local comment_nvim = {
	"numToStr/Comment.nvim",
	lazy = false,
}

comment_nvim.config = function()
	require("Comment").setup({})
end

return comment_nvim
