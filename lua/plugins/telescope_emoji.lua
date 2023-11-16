local telescope_emoji = {
	"xiyaowong/telescope-emoji.nvim",
}

telescope_emoji.config = function()
	require("telescope").load_extension("emoji")
end

return telescope_emoji
