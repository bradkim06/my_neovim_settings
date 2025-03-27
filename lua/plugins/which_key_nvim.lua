local which_key_nvim = {
	"folke/which-key.nvim",
	event = "VeryLazy",
}

which_key_nvim.init = function()
	vim.o.timeout = true
	vim.o.timeoutlen = 300

	vim.api.nvim_create_autocmd("ColorScheme", {
		pattern = "*",
		callback = function()
			vim.api.nvim_set_hl(0, "WhichKeyValue", { fg = "#EEEEEE" })
		end,
	})
end

which_key_nvim.opts = {
	-- your configuration comes here
	-- or leave it empty to use the default settings
	-- refer to the configuration section below
}

return which_key_nvim
