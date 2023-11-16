local telescope_emoji = {
	"xiyaowong/telescope-emoji.nvim",
	cmd = "Telescope emoji",
	dependencies = "nvim-telescope/telescope.nvim",
}

telescope_emoji.init = function()
	require("telescope").load_extension("emoji")
end

return telescope_emoji
