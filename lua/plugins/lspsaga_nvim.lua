local lspsaga_nvim = {
	"nvimdev/lspsaga.nvim",
	config = function()
		require("lspsaga").setup({
			lightbulb = {
				enable = true,
				sign = false,
				debounce = 10,
				sign_priority = 40,
				virtual_text = true,
				enable_in_insert = true,
			},

			code_action = {
				num_shortcut = true,
				show_server_name = true,
				extend_gitsigns = true,
				only_in_cursor = false,
				max_height = 0.5,
				keys = {
					quit = "q",
					exec = "<CR>",
				},
			},

			finder = {
				keys = {
					toggle_or_open = "<cr>",
				},
			},

			rename = {
				in_select = true,
				auto_save = false,
				project_max_width = 0.5,
				project_max_height = 0.5,
				keys = {
					quit = "<C-c>",
					exec = "<CR>",
					select = "x",
				},
			},

			ui = {
				border = "double",
				-- devicon = true,
				-- foldericon = true,
				-- title = true,
				-- expand = "⊞",
				-- collapse = "⊟",
				-- code_action = "💡",
				-- actionfix = " ",
				-- lines = { "┗", "┣", "┃", "━", "┏" },
				-- kind = nil,
				-- imp_sign = "󰳛 ",
			},

			ft = { "c", "cpp", "lua" },
		})

		local opts = { noremap = true }
		vim.keymap.set("n", "gd", "<CMD>Lspsaga goto_definition<CR>", opts)
		vim.keymap.set("n", "gp", "<CMD>Lspsaga peek_definition<CR>", opts)
		vim.keymap.set("n", "gr", "<CMD>Lspsaga finder def+ref<CR>", opts)
		vim.keymap.set({ "n", "t" }, "<leader>t", "<cmd>Lspsaga term_toggle<cr>", opts)
		vim.keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<cr>", opts)
		vim.keymap.set({ "n", "x" }, "<leader>ca", "<cmd>Lspsaga code_action<cr>", opts)

		-- hover
		vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<cr>", opts)

		-- diagnostics
		vim.keymap.set("n", "[d", "<CMD>Lspsaga diagnostic_jump_prev<CR>", opts)
		vim.keymap.set("n", "]d", "<CMD>Lspsaga diagnostic_jump_next<CR>", opts)
		vim.keymap.set("n", "gG", "<cmd>Lspsaga show_workspace_diagnostics<cr>", opts)
	end,
	dependencies = {
		"nvim-treesitter/nvim-treesitter", -- optional
		"nvim-tree/nvim-web-devicons", -- optional
	},
}

return lspsaga_nvim
