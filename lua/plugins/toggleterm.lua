-- lua/plugins/toggleterm.lua
return {
	"akinsho/toggleterm.nvim",
	version = "*",
	event = "VeryLazy",
	config = function()
		require("toggleterm").setup({
			size = 20,
			open_mapping = [[<c-\>]], -- Ctrl + \ 로 토글 (원하는 키로 변경 가능)
			hide_numbers = true,
			shade_filetypes = {},
			shade_terminals = true,
			shading_factor = 2,
			start_in_insert = true,
			insert_mappings = true,
			persist_size = true,
			direction = "float", -- 플로팅 창으로 열기
			close_on_exit = true,
			shell = vim.o.shell,
			float_opts = {
				border = "curved",
				winblend = 0,
				highlights = {
					border = "Normal",
					background = "Normal",
				},
			},
		})

		-- lspsaga에서 사용하던 <leader>t 키매핑 설정
		local opts = { noremap = true, silent = true, desc = "Toggle Terminal" }
		vim.keymap.set({ "n", "t" }, "<leader>t", "<cmd>ToggleTerm<cr>", opts)
	end,
}
