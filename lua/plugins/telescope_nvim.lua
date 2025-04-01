-----------------------------------------------------------
-- telescope.nvim: 고급 검색/탐색 인터페이스
-- 리팩토링 + 주석 확장 예시
-----------------------------------------------------------
local M = {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.4",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = "VeryLazy", -- Lazy.nvim에서 특정 이벤트가 발생할 때 로드
}

-----------------------------------------------------------
-- 플러그인 설정 함수 (Lazy.nvim에서 config 호출)
-----------------------------------------------------------
function M.config()
	-----------------------------------------------------------
	-- 1. 필요한 모듈 불러오기
	-----------------------------------------------------------
	local telescope = require("telescope")
	local action_layout = require("telescope.actions.layout")
	local actions = require("telescope.actions")
	local previewers = require("telescope.previewers")
	local Job = require("plenary.job")

	-----------------------------------------------------------
	-- 2. 바이너리 파일 미리보기 방지용 커스텀 maker
	-----------------------------------------------------------
	-- (파일이 text/* MIME이면 기본 프리뷰어 사용,
	--  그렇지 않으면 "BINARY"만 표기하도록 함)
	-----------------------------------------------------------
	local function new_maker(filepath, bufnr, opts)
		filepath = vim.fn.expand(filepath)
		Job:new({
			command = "file",
			args = { "--mime-type", "-b", filepath },
			on_exit = function(j)
				local mime_type = vim.split(j:result()[1], "/")[1]
				if mime_type == "text" then
					previewers.buffer_previewer_maker(filepath, bufnr, opts)
				else
					vim.schedule(function()
						vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
					end)
				end
			end,
		}):sync()
	end

	-----------------------------------------------------------
	-- 3. Telescope 기본 설정 (telescope.setup)
	-----------------------------------------------------------
	telescope.setup({
		defaults = {
			-- (a) 바이너리 파일 처리
			buffer_previewer_maker = new_maker,

			-- (b) 레이아웃 설정: 세로(vertical) + 높이 99%
			layout_strategy = "vertical",
			layout_config = { height = 0.99 },

			-- (c) 기본 키 매핑: 프리뷰 토글, <esc>로 종료
			mappings = {
				n = {
					["<M-p>"] = action_layout.toggle_preview, -- alt + p
				},
				i = {
					["<M-p>"] = action_layout.toggle_preview,
					["<esc>"] = actions.close,
				},
			},
		},

		pickers = {
			-- (d) find_files 시 fd 사용, .git / .cache 제외
			find_files = {
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

		-- (e) 확장(extensions) 사용 시 여기에 설정 가능
		-- extensions = {
		--   ...
		-- },
	})

	-----------------------------------------------------------
	-- 4. 사용자 정의 명령어: :Grep <word>
	-----------------------------------------------------------
	-- - 입력한 <word>를 telescope.builtin.grep_string()으로 검색
	-- - 50ms 뒤 해당 단어를 커서 위치에 삽입
	-- 예) :Grep foo => foo 검색 + 편집에 foo 삽입
	-----------------------------------------------------------
	vim.api.nvim_create_user_command("Grep", function(opts)
		require("telescope.builtin").grep_string({
			search = opts.fargs[1],
			file_ignore_patterns = { ".git/" },
		})
		vim.defer_fn(function()
			vim.api.nvim_put({ opts.fargs[1] .. " " }, "c", true, true)
		end, 50)
	end, { nargs = 1 })

	-----------------------------------------------------------
	-- 5. Keymap 설정 (nvim_set_keymap 대신 vim.keymap.set 사용)
	-----------------------------------------------------------
	local builtin = require("telescope.builtin")
	local function map_opts(desc)
		return { noremap = true, silent = true, desc = desc }
	end

	-- <leader><leader> : find_files
	vim.keymap.set("n", "<leader><leader>", builtin.find_files, map_opts("Telescope: find files"))

	-- <leader>g        : find_files (unrestricted) => fd --unrestricted
	vim.keymap.set(
		"n",
		"<leader>g",
		"<cmd>Telescope find_files find_command=fd,--unrestricted<cr>",
		map_opts("Telescope: find files (unrestricted)")
	)

	-- <leader>ag       : grep_string (현재 단어 검색)
	vim.keymap.set("n", "<leader>ag", builtin.grep_string, map_opts("Telescope: grep current word"))

	-- <leader>/        : live_grep (실시간 검색)
	vim.keymap.set("n", "<leader>/", builtin.live_grep, map_opts("Telescope: live grep"))

	-- <F1>             : Telescope 명령어 목록/메인 메뉴
	vim.keymap.set("n", "<F1>", "<cmd>Telescope<cr>", map_opts("Telescope: open command palette"))
end

return M
