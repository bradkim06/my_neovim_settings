-----------------------------------------------------------
-- Neovim 기본 설정 및 커스터마이징
-----------------------------------------------------------

-- ===================================================================
-- 1. 파일 타입 및 구문 강조 설정
-- ===================================================================
-- 구문 강조 및 파일 타입 플러그인 활성화
vim.cmd("syntax on")
vim.cmd("filetype plugin on")

-- JSON 파일의 확장자를 jsonc 로 인식하도록 설정
local jsonc_group = vim.api.nvim_create_augroup("JsoncFiletype", { clear = true })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = jsonc_group,
	pattern = "*.json",
	command = "set filetype=jsonc",
})

-----------------------------------------------------------
-- 2. 기본 옵션 설정 (vim.opt 사용)
-----------------------------------------------------------
local set = vim.opt

set.modifiable = true

-- 일반 동작 관련 설정
set.hidden = true -- 수정한 버퍼를 저장하지 않고 숨길 수 있음
set.encoding = "utf-8" -- 내부 인코딩
set.fileencodings = "utf8" -- 파일 인코딩
set.clipboard = "unnamedplus" -- 시스템 클립보드 사용
set.cursorline = true -- 현재 커서 줄 강조

-- 검색 관련 설정
set.incsearch = true -- 검색 시 실시간 하이라이트
set.hlsearch = true -- 검색 결과 하이라이트
set.ignorecase = true -- 대소문자 무시 검색
set.smartcase = true -- 대소문자 섞여 있으면 구분

-- 숫자 및 커서 관련 설정
set.number = true -- 행 번호 표시
set.ruler = false -- 상태 표시줄의 ruler 비활성화

-- 파일 탐색 및 버퍼 관련 옵션
set.wildmode = "full" -- 명령행 완성 모드 개선
set.wildignorecase = true -- 파일명 완성 시 대소문자 무시

-- 탭 및 들여쓰기 관련 설정
set.expandtab = true -- 탭 대신 공백 사용
set.shiftwidth = 4 -- 자동 들여쓰기 간격
set.smartindent = true -- 스마트 자동 들여쓰기
set.tabstop = 4 -- 탭 너비 설정
set.softtabstop = 4 -- 입력 시 탭 너비

-- 기타 인터페이스 설정
set.mouse = "a" -- 마우스 사용 가능
set.shortmess:append("sI") -- Neovim 인트로 비활성화
set.signcolumn = "yes" -- 항상 부호 열 표시
set.splitbelow = true -- 수평 분할 시 아래쪽에 새 창
set.splitright = true -- 수직 분할 시 오른쪽에 새 창
set.timeoutlen = 400 -- 키 입력 대기 시간 (ms)
set.undofile = true -- 언두 파일 활성화

-- 코드 포매팅 관련
set.nrformats = "" -- 모든 숫자를 10진법으로 처리 (선행 0 무시)
set.textwidth = 80 -- 자동 줄바꿈 기준 길이 80자
if set.colorcolumn then -- 수직 컬럼 표시 (80자 위치)
	set.colorcolumn = "80"
end

-----------------------------------------------------------
-- 3. Python 인터프리터 설정
-----------------------------------------------------------
-- Neovim에서 사용할 Python3 인터프리터 경로 지정
vim.g.python3_host_prog = "/opt/homebrew/bin/python3"

-----------------------------------------------------------
-- 4. 키매핑 설정 (Keymaps)
-----------------------------------------------------------
-- 기본 키 매핑 옵션
local opts = { noremap = true, silent = true }

-- [4.1] MYVIMRC 관련 매핑
vim.keymap.set("n", "<leader>ve", ":edit $MYVIMRC<cr>", opts) -- MYVIMRC 편집
vim.keymap.set("n", "<leader>vl", ":edit ~/.config/nvim/lua/basic.lua<cr>", opts) -- 기본 설정 파일 편집
vim.keymap.set("n", "<leader>vs", ":source $MYVIMRC<cr>", opts) -- 설정 파일 재로딩

-- [4.2] 버퍼 관리 매핑
-- 현재 버퍼만 남기고 모두 닫기
vim.cmd('command! BufOnly silent! execute "%bd|e#|bd#"')
vim.keymap.set("n", "<S-q>", ":BufOnly<CR>", opts)
-- 현재 버퍼 닫기
vim.keymap.set("n", "<leader>q", ":bd<CR>", opts)
-- 버퍼 간 이동
vim.keymap.set("n", "<Tab>", ":bnext<CR>", opts) -- 다음 버퍼
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", opts) -- 이전 버퍼

-- [4.3] 유용한 편집 매핑
-- 전체 선택 (Visual 모드)
vim.keymap.set("n", "<C-a>", "ggVG", opts)

-- [4.4] 시각적 선택 영역 검색 설정
-- 선택 영역을 검색 패턴으로 설정하는 함수 (글로벌 함수로 등록)
local function set_search_pattern()
	-- 현재 's' 레지스터 값을 임시 저장
	local temp = vim.fn.getreg("s")
	-- 선택 영역을 's' 레지스터에 복사
	vim.cmd('norm! gv"sy')
	-- 's' 레지스터 값을 검색 패턴으로 설정 (특수문자 및 개행 문자 이스케이프)
	vim.fn.setreg("/", "\\V" .. vim.fn.substitute(vim.fn.escape(vim.fn.getreg("s"), "/\\"), "\\n", "\\\\n", "g"))
	-- 원래 's' 레지스터 값 복원
	vim.fn.setreg("s", temp)
end
_G.SetSearchPattern = set_search_pattern -- _G에 등록하여 keymap에서 사용

-- Visual 모드에서 * 와 # 키를 사용해 선택 영역 검색 실행
vim.keymap.set("x", "*", [[:<C-u>lua _G.SetSearchPattern()<CR>/<C-R>=@/<CR><CR>]], opts)
vim.keymap.set("x", "#", [[:<C-u>lua _G.SetSearchPattern()<CR>/<C-R>=@/<CR><CR>]], opts)

-----------------------------------------------------------
-- 5. 컬러 및 터미널 설정
-----------------------------------------------------------
-- 24-bit (True Color) 모드 활성화
if os.getenv("TMUX") == nil and os.getenv("TERM_PROGRAM") ~= "Apple_Terminal" then
	if vim.fn.has("termguicolors") then
		vim.o.termguicolors = true
	end
end

-- Neovim 터미널 색상 설정
if vim.fn.has("nvim") == 1 then
	-- Neovim 내장 터미널 색상 지정 (각 색상은 필요에 따라 커스터마이징 가능)
	vim.g.terminal_color_0 = "#4e4e4e"
	vim.g.terminal_color_1 = "#d68787"
	vim.g.terminal_color_2 = "#5f865f"
	vim.g.terminal_color_3 = "#d8af5f"
	vim.g.terminal_color_4 = "#85add4"
	vim.g.terminal_color_5 = "#d7afaf"
	vim.g.terminal_color_6 = "#87afaf"
	vim.g.terminal_color_7 = "#d0d0d0"
	vim.g.terminal_color_8 = "#626262"
	vim.g.terminal_color_9 = "#d75f87"
	vim.g.terminal_color_10 = "#87af87"
	vim.g.terminal_color_11 = "#ffd787"
	vim.g.terminal_color_12 = "#add4fb"
	vim.g.terminal_color_13 = "#ffafaf"
	vim.g.terminal_color_14 = "#87d7d7"
	vim.g.terminal_color_15 = "#e4e4e4"

	-- 채움 문자(fillchars) 설정 : 수직 분할선 및 폴드라인 스타일
	vim.o.fillchars = "vert:|,fold:-"

	-- 파일 열 때 마지막 커서 위치 복원
	local cursor_group = vim.api.nvim_create_augroup("RestoreCursor", { clear = true })
	vim.api.nvim_create_autocmd("BufReadPost", {
		group = cursor_group,
		pattern = "*",
		callback = function()
			local mark = vim.api.nvim_buf_get_mark(0, '"')
			local lcount = vim.api.nvim_buf_line_count(0)
			if mark[1] > 0 and mark[1] <= lcount then
				vim.cmd('normal! g`"')
			end
		end,
	})
else
	-- Vim (Neovim 이외)에서 사용할 터미널 ANSI 색상 설정
	vim.g.terminal_ansi_colors = {
		"#4e4e4e",
		"#d68787",
		"#5f865f",
		"#d8af5f",
		"#85add4",
		"#d7afaf",
		"#87afaf",
		"#d0d0d0",
		"#626262",
		"#d75f87",
		"#87af87",
		"#ffd787",
		"#add4fb",
		"#ffafaf",
		"#87d7d7",
		"#e4e4e4",
	}
end

-----------------------------------------------------------
-- 6. 기타 유틸리티 매핑 및 함수
-----------------------------------------------------------
-- [6.1] 날짜/시간 입력 매핑 (입력 모드)
vim.keymap.set("i", "<F5>", '<C-R>=os.date("%Y-%m-%d")<cr>', {}) -- 현재 날짜 (YYYY-MM-DD)
vim.keymap.set("i", "<F6>", '<C-R>=os.date("%Y-%m-%dT%H:%M:%S")<cr>', {}) -- 현재 날짜 및 시간 (ISO 8601)

-- [6.2] 현재 파일 이름 변경 함수
local function rename_file()
	local old_name = vim.fn.expand("%") -- 현재 파일 경로
	local new_name = vim.fn.input("New file name: ", old_name, "file")
	if new_name ~= "" and new_name ~= old_name then
		vim.cmd("saveas " .. new_name) -- 새 이름으로 저장
		vim.cmd("silent !rm " .. old_name) -- 이전 파일 삭제
		vim.cmd("redraw") -- 화면 갱신
	end
end
vim.keymap.set("n", "<leader>n", ":lua rename_file()<cr>", opts)

-- [6.3] 외부 명령어 실행 매핑 (예: west 명령어)
vim.keymap.set("n", "<F3>", ":!west build<cr>", opts) -- 빌드 실행
vim.keymap.set("n", "<F4>", ":!west flash<cr>", opts) -- 플래시 실행

-- [6.4] Neovim TUI에서 True Color 사용 활성화
vim.g.NVIM_TUI_ENABLE_TRUE_COLOR = 1

-- chatgpt_integration.lua
-- Neovim → ChatGPT macOS 앱 연동 스크립트 (기능별 정리)

------------------------------
-- 1) 공통 Helper 함수
------------------------------
-- 클립보드에 저장된 텍스트를 ChatGPT 앱에 붙여넣기하고 전송
local function chatgpt_activate_and_send()
	-- ChatGPT 앱 활성화
	os.execute([[osascript -e 'tell application "ChatGPT" to activate']])
	-- 붙여넣기 (⌘+V)
	os.execute([[osascript -e 'tell application "System Events" to keystroke "v" using {command down}']])
	-- 엔터 또는 Shift+엔터 전송 (필요 시 변경)
	os.execute([[osascript -e 'tell application "System Events" to key code 36 using {shift down}']])
end

-- 클립보드에 텍스트 복사
local function copy_to_clipboard(text)
	vim.fn.setreg("+", text)
end

------------------------------
-- 2) 비주얼 모드 선택 영역 전송
------------------------------
-- 선택 영역 문자열 추출
local function get_visual_selection()
	local s_pos = vim.fn.getpos("'<")
	local e_pos = vim.fn.getpos("'>")
	local s_line, s_col = s_pos[2], s_pos[3]
	local e_line, e_col = e_pos[2], e_pos[3]
	local lines = vim.fn.getline(s_line, e_line)
	lines[1] = string.sub(lines[1], s_col)
	lines[#lines] = string.sub(lines[#lines], 1, e_col)
	return table.concat(lines, "\n")
end

-- 선택된 코드 전송 함수 (전역)
_G.send_selection_to_chatgpt = function()
	local sel = get_visual_selection()
	local wrapped = string.format("<user__selection>\n%s\n</user__selection>", sel)
	copy_to_clipboard(wrapped)
	chatgpt_activate_and_send()
end

-- 매핑: 비주얼 모드에서 <Leader>cs
vim.api.nvim_set_keymap(
	"v",
	"<Leader>cs",
	":<C-u>lua send_selection_to_chatgpt()<CR>",
	{ noremap = true, silent = true }
)

------------------------------
-- 3) 버퍼 전체 내용 전송
------------------------------
_G.send_buffer_to_chatgpt = function()
	local lines = vim.fn.getline(1, "$")
	local text = table.concat(lines, "\n")
	local wrapped = string.format("<user__selection>\n%s\n</user__selection>", text)
	copy_to_clipboard(wrapped)
	chatgpt_activate_and_send()
end

-- 매핑: 노멀 모드에서 <Leader>cs
vim.api.nvim_set_keymap("n", "<Leader>cf", ":<C-u>lua send_buffer_to_chatgpt()<CR>", { noremap = true, silent = true })

-- 2) Telescope 멀티 셀렉션용 함수
local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
	vim.notify("Please install nvim-telescope/telescope.nvim to use csf with Telescope", vim.log.levels.ERROR)
	return
end

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

_G.send_selected_files_to_chatgpt = function()
	pickers
		.new({}, {
			prompt_title = "Select files to send → ChatGPT",
			finder = finders.new_oneshot_job({ "fd", "--type", "f", "--hidden", "--exclude", ".git" }, {}),
			previewer = conf.file_previewer({}),
			sorter = conf.file_sorter({}),
			attach_mappings = function(prompt_bufnr, map)
				-- <Tab> 토글, <CR> 선택 완료
				map("i", "<Tab>", actions.toggle_selection + actions.move_selection_worse)
				map("n", "<Tab>", actions.toggle_selection + actions.move_selection_worse)

				local function send_and_close()
					-- 1) 현재 Telescope picker 객체 가져오기
					local picker = action_state.get_current_picker(prompt_bufnr)
					-- 2) 토글된(멀티) 셀렉션 목록 가져오기
					local selections = picker:get_multi_selection()

					if #selections == 0 then
						vim.notify("⚠️ No files selected.", vim.log.levels.WARN)
					else
						local chunks = {}
						for _, entry in ipairs(selections) do
							-- entry.value 까지 포함해서 파일 경로 확보
							local path = entry.path or entry.filename or entry.value
							-- 경로가 문자열이고 실제로 읽을 수 있는지 확인
							if type(path) ~= "string" or vim.fn.filereadable(path) == 0 then
								vim.notify("⚠️ Cannot read file: " .. vim.inspect(path), vim.log.levels.WARN)
							else
								local name = vim.fn.fnamemodify(path, ":t")
								local lines = vim.fn.readfile(path)
								table.insert(chunks, "### " .. name)
								table.insert(chunks, table.concat(lines, "\n"))
							end
						end
						local body = table.concat(chunks, "\n\n")
						local wrapped = string.format("<user__selection>\n%s\n</user__selection>", body)
						copy_to_clipboard(wrapped)
						chatgpt_activate_and_send()
					end
					actions.close(prompt_bufnr)
				end

				map("i", "<CR>", send_and_close)
				map("n", "<CR>", send_and_close)
				return true
			end,
		})
		:find()
end

-- 3) 매핑 (Normal 모드)
vim.api.nvim_set_keymap(
	"n",
	"<Leader>csf",
	":lua send_selected_files_to_chatgpt()<CR>",
	{ noremap = true, silent = true }
)
