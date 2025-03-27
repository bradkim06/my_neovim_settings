local compiler_nvim = {
	{ -- This plugin
		"Zeioth/compiler.nvim",
		cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
		dependencies = { "stevearc/overseer.nvim" },
		opts = {},
	},
	{ -- The task runner we use
		"stevearc/overseer.nvim",
		commit = "68a2d344cea4a2e11acfb5690dc8ecd1a1ec0ce0",
		cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
		opts = {
			task_list = {
				direction = "bottom",
				min_height = 25,
				max_height = 25,
				default_detail = 1,
			},
		},
	},
}

local opts = { noremap = true }
-- Open compiler
vim.keymap.set("n", "<F7>", "<cmd>CompilerOpen<cr>", opts)

-- Toggle compiler results
vim.api.nvim_set_keymap("n", "<F8>", "<cmd>CompilerToggleResults<cr>", opts)

return compiler_nvim
