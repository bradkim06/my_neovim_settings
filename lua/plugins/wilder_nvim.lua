local wilder_nvim = {
	"gelguy/wilder.nvim",
	event = "VeryLazy",
	dependencies = { "romgrk/fzy-lua-native", "nixprime/cpsm", "sharkdp/fd", "nvim-tree/nvim-web-devicons" },
}

wilder_nvim.config = function()
	-- config goes here
	local wilder = require("wilder")
	wilder.setup({ modes = { ":", "/", "?" } })

	wilder.set_option("pipeline", {
		wilder.branch(
			wilder.python_file_finder_pipeline({
				file_command = function(ctx, arg)
					if string.find(arg, ".") ~= nil then
						return { "fd", "-tf", "-H" }
					else
						return { "fd", "-tf" }
					end
				end,
				dir_command = { "fd", "-td" },
				-- use {'cpsm_filter'} for performance, requires cpsm vim plugin
				-- found at https://github.com/nixprime/cpsm
				filters = { "fuzzy_filter", "difflib_sorter" },
			}),

			wilder.substitute_pipeline({
				pipeline = wilder.python_search_pipeline({
					skip_cmdtype_check = 1,
					pattern = wilder.python_fuzzy_pattern({
						start_at_boundary = 0,
					}),
				}),
			}),
			wilder.cmdline_pipeline({
				fuzzy = 2,
				fuzzy_filter = wilder.lua_fzy_filter(),
			}),
			{
				wilder.check(function(ctx, x)
					return x == ""
				end),
				wilder.history(),
			},
			wilder.python_search_pipeline({
				-- can be set to wilder#python_fuzzy_delimiter_pattern() for stricter fuzzy matching
				pattern = wilder.python_fuzzy_pattern(),
				-- omit to get results in the order they appear in the buffer
				sorter = wilder.python_difflib_sorter(),
				-- can be set to 're2' for performance, requires pyre2 to be installed
				-- see :h wilder#python_search() for more details
				engine = "re2",
			})
		),
	})

	local highlighters = {
		wilder.pcre2_highlighter(),
		wilder.lua_fzy_highlighter(),
	}

	local popupmenu_renderer = wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
		-- 'single', 'double', 'rounded' or 'solid'
		-- can also be a list of 8 characters, see :h wilder#popupmenu_palette_theme() for more details
		border = "rounded",
		max_height = "90%", -- max height of the palette
		min_height = 0, -- set to the same as 'max_height' for a fixed height window
		prompt_position = "bottom", -- 'top' or 'bottom' to set the location of the prompt
		reverse = 0, -- set to 1 to reverse the order of the list, use in combination with 'prompt_position'
		highlighter = highlighters,
		highlights = {
			accent = wilder.make_hl("WilderAccent", "Pmenu", { { a = 1 }, { a = 1 }, { foreground = "#f4468f" } }),
		},

		left = {
			" ",
			wilder.popupmenu_devicons(),
		},
		right = {
			" ",
			wilder.popupmenu_scrollbar(),
		},
	}))

	wilder.set_option(
		"renderer",
		wilder.renderer_mux({
			[":"] = popupmenu_renderer,
			["/"] = popupmenu_renderer,
			substitute = popupmenu_renderer,
		})
	)
end

return wilder_nvim
