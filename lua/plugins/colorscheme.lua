-- main colorscheme
local colorscheme = {
	"catppuccin/nvim",
	"folke/tokyonight.nvim",
	{
		"rebelot/kanagawa.nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			-- load the colorscheme here
			-- vim.o.background = ""
			vim.cmd.colorscheme("kanagawa-wave")
		end,
	},
}

return colorscheme
