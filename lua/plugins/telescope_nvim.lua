local telescope_nvim = {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.4",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = "VeryLazy",
}

telescope_nvim.config = function()
	local action_layout = require("telescope.actions.layout")
	require("telescope").setup({
		defaults = {
			layout_strategy = "vertical",
			layout_config = { height = 0.99 },

			mappings = {
				n = {
					["<C-t>"] = action_layout.toggle_preview,
				},
				i = {
					["<C-t>"] = action_layout.toggle_preview,
				},
			},
		},
	})

	vim.api.nvim_create_user_command("Grep", function(opts)
		require("telescope.builtin").grep_string({ search = opts.fargs[1], file_ignore_patterns = { ".git/" } })
		vim.defer_fn(function()
			vim.api.nvim_put({ opts.fargs[1] .. " " }, "c", true, true)
		end, 50)
	end, { nargs = 1 })

	vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = "#C70039" })
	-- vim.api.nvim_set_hl(0, "TelescopePreviewLine", { bg = "#EEEEEE" })

	local builtin = require("telescope.builtin")
	local opts = function(desc)
		return { noremap = true, silent = true, desc = desc }
	end
	vim.keymap.set("n", "<leader><leader>", builtin.find_files, opts("find files"))
	-- vim.keymap.set("n", "<leader>ag", builtin.grep_string, {})
	vim.keymap.set("n", "<leader>ag", ":Grep <C-r><C-w><cr>", opts("grep current word"))
	vim.keymap.set("n", "<leader>/", builtin.live_grep, opts("live grep"))
	vim.keymap.set("n", "<F1>", "<cmd>Telescope<cr>", opts("Telescope"))
end

return telescope_nvim
