local telescope_nvim = {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.4",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = "VeryLazy",
}

telescope_nvim.config = function()
	local action_layout = require("telescope.actions.layout")
	--<Esc>삽입 모드에서 종료하기 위한 매핑
	local actions = require("telescope.actions")

	--바이너리 미리보기를 하지 마세요
	local previewers = require("telescope.previewers")
	local Job = require("plenary.job")
	local new_maker = function(filepath, bufnr, opts)
		filepath = vim.fn.expand(filepath)
		Job:new({
			command = "file",
			args = { "--mime-type", "-b", filepath },
			on_exit = function(j)
				local mime_type = vim.split(j:result()[1], "/")[1]
				if mime_type == "text" then
					previewers.buffer_previewer_maker(filepath, bufnr, opts)
				else
					-- maybe we want to write something to the buffer here
					vim.schedule(function()
						vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
					end)
				end
			end,
		}):sync()
	end

	require("telescope").setup({
		defaults = {
			buffer_previewer_maker = new_maker,

			layout_strategy = "vertical",
			layout_config = { height = 0.99 },

			mappings = {
				n = {
					["<M-p>"] = action_layout.toggle_preview,
				},
				i = {
					["<M-p>"] = action_layout.toggle_preview,
					["<esc>"] = actions.close,
				},
			},
		},

		pickers = {
			find_files = {
				-- find_command = {
				-- 	"rg",
				-- 	"--files",
				-- 	"--hidden",
				-- 	"--follow",
				-- 	"--no-ignore-vcs",
				-- 	"'!.cache'",
				-- },
				find_command = {
					"fd",
					"--hidden",
					"--exclude",
					".cache",
					"--exclude",
					".git",
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

	-- local color = {
	-- TelescopeMatching = {
	-- 	fg = "#FF8080",
	-- },
	-- TelescopePreviewLine = {
	-- 	bg = "#625e5a",
	-- fg = "#FF8080",
	-- },
	-- }
	-- for hl, col in pairs(color) do
	-- 	vim.api.nvim_set_hl(0, hl, col)
	-- end

	local builtin = require("telescope.builtin")
	local opts = function(desc)
		return { noremap = true, silent = true, desc = desc }
	end
	vim.keymap.set("n", "<leader><leader>", builtin.find_files, opts("find files"))
	vim.keymap.set("n", "<leader>g", "<cmd>Telescope find_files find_command=fd,--unrestricted<cr>", opts("find files"))
	vim.keymap.set("n", "<leader>ag", builtin.grep_string, {})
	-- vim.keymap.set("n", "<leader>ag", ":Grep <C-r><C-w><cr>", opts("grep current word"))
	vim.keymap.set("n", "<leader>/", builtin.live_grep, opts("live grep"))
	vim.keymap.set("n", "<F1>", "<cmd>Telescope<cr>", opts("Telescope"))
end

return telescope_nvim
