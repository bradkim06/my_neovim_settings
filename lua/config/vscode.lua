-- ===================================================================
-- 1. 핵심 옵션 설정 (Vim Behavior)
-- ===================================================================
local set = vim.opt

-- [유지] Neovim의 핵심 편집 동작과 관련된 설정들입니다.
set.hidden = true -- 수정된 버퍼를 저장하지 않고 다른 파일로 전환 허용
set.clipboard = "unnamedplus" -- 시스템 클립보드 연동 (매우 중요)
set.incsearch = true -- 검색 시 실시간 하이라이트
set.hlsearch = true -- 검색 결과 하이라이트
set.ignorecase = true -- 검색 시 대소문자 무시
set.smartcase = true -- 검색어에 대문자가 있으면 대소문자 구분
set.undofile = true -- 언두(undo) 기록을 파일로 저장하여 Neovim 재시작 후에도 복구
set.splitbelow = true -- 수평 분할 시 아래쪽에 새 창 생성
set.splitright = true -- 수직 분할 시 오른쪽에 새 창 생성
set.timeoutlen = 400 -- 키 입력 대기 시간 (ms)

-- [VSCode 권장] 아래 옵션들은 VSCode의 settings.json에서 관리하는 것이 더 효율적입니다.
-- set.number = true
-- set.cursorline = true
-- set.expandtab = true
-- set.shiftwidth = 4
-- set.tabstop = 4
-- set.colorcolumn = "80"
-- set.mouse = "a"

-- [제거] VSCode 환경에서는 불필요하거나 VSCode가 직접 처리하는 옵션들입니다.
-- set.syntax, set.filetype, set.termguicolors, set.signcolumn, set.ruler 등

-----------------------------------------------------------
-- 2. 키매핑 설정 (Keymaps)
-----------------------------------------------------------
local opts = { noremap = true, silent = true }

-- [유지] 설정 파일 편집 및 리로드
vim.keymap.set("n", "<leader>ve", ":edit $MYVIMRC<cr>", opts)
vim.keymap.set("n", "<leader>vs", ":source $MYVIMRC<cr>", opts)

-- [유지] 버퍼(VSCode 탭) 관리
-- 참고: VSCode의 기본 단축키(Ctrl+W, Ctrl+Tab)도 동일하게 작동합니다.
vim.keymap.set("n", "<leader>q", ":bd<CR>", opts)
vim.keymap.set("n", "<Tab>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", opts)

-- [유지] 유용한 편집 매핑
vim.keymap.set("n", "<C-a>", "ggVG", opts) -- 전체 선택

-- [유지] Visual 모드에서 선택 영역 검색
local function set_search_pattern()
	local temp = vim.fn.getreg("s")
	vim.cmd('norm! gv"sy')
	vim.fn.setreg("/", "\\V" .. vim.fn.substitute(vim.fn.escape(vim.fn.getreg("s"), "/\\"), "\\n", "\\\\n", "g"))
	vim.fn.setreg("s", temp)
end
_G.SetSearchPattern = set_search_pattern
vim.keymap.set("x", "*", [[:<C-u>lua _G.SetSearchPattern()<CR>/<C-R>=@/<CR><CR>]], opts)
vim.keymap.set("x", "#", [[:<C-u>lua _G.SetSearchPattern()<CR>/<C-R>=@/<CR><CR>]], opts)

-----------------------------------------------------------
-- 3. 유틸리티 함수 및 매핑
-----------------------------------------------------------
-- [유지] 날짜/시간 입력
vim.keymap.set("i", "<F5>", '<C-R>=os.date("%Y-%m-%d")<cr>', {})
vim.keymap.set("i", "<F6>", '<C-R>=os.date("%Y-%m-%dT%H:%M:%S")<cr>', {})

-- [수정 권장] 파일 이름 변경
-- 기존 방식은 VSCode의 파일 탐색기와 연동되지 않을 수 있습니다.
-- 이 키맵 대신 VSCode 파일 탐색기에서 파일을 선택하고 F2 키를 누르는 것을 권장합니다.
local function rename_file()
	local old_name = vim.fn.expand("%:p") -- 현재 파일의 전체 경로
	local new_name = vim.fn.input("New file name: ", old_name, "file")
	if new_name ~= "" and new_name ~= old_name then
		-- vim.cmd('saveas ' .. new_name) -- 새 이름으로 저장
		-- vim.cmd('silent !rm ' .. old_name) -- 이전 파일 삭제 (위험할 수 있음)
		-- vim.cmd('redraw')
		vim.notify("파일 이름 변경은 VSCode 탐색기에서 F2를 사용해주세요.", vim.log.levels.INFO)
	end
end
vim.keymap.set("n", "<leader>n", ":lua rename_file()<cr>", opts)
