local dressing_nvim = {
	"stevearc/dressing.nvim",
}

dressing_nvim.config = function()
	require("dressing").setup({
		input = {
			win_options = {
				winhighlight = "NormalFloat:DiagnosticError",
			},
		},

		select = {
			get_config = function(opts)
				if opts.kind == "codeaction" then
					return {
						backend = "nui",
						nui = {
							relative = "cursor",
							max_width = 40,
						},
					}
				end
			end,
		},
	})
end

return dressing_nvim
