-----------------------------------------------------------
-- gitsigns.nvim 플러그인 설정 (lazy.nvim 관리)
-----------------------------------------------------------
local gitsigns_nvim = {
	"lewis6991/gitsigns.nvim", -- Git 변경사항을 표시하는 플러그인
	event = "BufRead", -- 버퍼를 읽을 때 플러그인 로드
}

-----------------------------------------------------------
-- 플러그인 설정 함수
-----------------------------------------------------------
gitsigns_nvim.config = function()
	require("gitsigns").setup({
		-----------------------------------------------------------
		-- 1. Git 변경사항에 따른 표시 모양 설정
		-----------------------------------------------------------
		signs = {
			add = { text = "+" }, -- 추가된 줄 표시
			change = { text = "│" }, -- 변경된 줄 표시
			delete = { text = "_" }, -- 삭제된 줄 표시 (아래쪽)
			topdelete = { text = "‾" }, -- 삭제된 줄 표시 (상단)
			changedelete = { text = "~" }, -- 변경 후 삭제된 줄 표시
			untracked = { text = "┆" }, -- 추적되지 않는 줄 표시
		},

		-- 사이드바에 git 기호를 표시 (toggle: :Gitsigns toggle_signs)
		signcolumn = true,
		-- 숫자 영역(highlight) 옵션 (toggle: :Gitsigns toggle_numhl)
		numhl = false,
		-- 변경된 줄 전체에 하이라이트 (toggle: :Gitsigns toggle_linehl)
		linehl = false,
		-- 단어 단위 변경 사항 하이라이트 (toggle: :Gitsigns toggle_word_diff)
		word_diff = false,

		-----------------------------------------------------------
		-- 2. Git 디렉토리 감시 및 파일 연결 옵션
		-----------------------------------------------------------
		watch_gitdir = {
			follow_files = true, -- 파일 이동/이름 변경을 감지
		},
		attach_to_untracked = true, -- 추적되지 않는 파일에도 gitsigns 적용

		-----------------------------------------------------------
		-- 3. 현재 커서 라인에 Git blame 정보 표시 옵션
		-----------------------------------------------------------
		current_line_blame = false, -- 기본적으로 표시하지 않음 (toggle: :Gitsigns toggle_current_line_blame)
		current_line_blame_opts = {
			virt_text = true, -- 버추얼 텍스트로 표시
			virt_text_pos = "eol", -- 행 끝에 위치 ('eol', 'overlay', 'right_align' 중 선택)
			delay = 1000, -- 표시 전 지연 시간 (ms)
			ignore_whitespace = false, -- 공백 변경도 반영
			virt_text_priority = 100, -- 버추얼 텍스트 우선순위
		},
		-- blame 정보 포맷 (작성자, 날짜, 요약)
		current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",

		-----------------------------------------------------------
		-- 4. 기타 설정
		-----------------------------------------------------------
		sign_priority = 6, -- git sign의 표시 우선순위
		update_debounce = 100, -- 업데이트 딜레이 (ms)
		status_formatter = nil, -- 기본 상태 표시 포맷 사용
		max_file_length = 40000, -- 파일 길이 제한 (줄 수) 초과 시 비활성화

		-----------------------------------------------------------
		-- 5. 미리보기 창 설정 (hunk 미리보기)
		-----------------------------------------------------------
		preview_config = {
			border = "single", -- 미리보기 창의 테두리 스타일
			style = "minimal", -- 최소한의 스타일 적용
			relative = "cursor", -- 커서 기준 위치
			row = 0, -- 행 오프셋
			col = 1, -- 열 오프셋
		},

		-----------------------------------------------------------
		-- 6. on_attach: 버퍼에 gitsigns가 연결될 때 실행
		-----------------------------------------------------------
		on_attach = function(bufnr)
			local gs = package.loaded.gitsigns

			-- 현재 버퍼에만 적용되는 키맵핑 설정 헬퍼 함수
			local function map(mode, lhs, rhs, opts)
				opts = opts or {}
				opts.buffer = bufnr
				vim.keymap.set(mode, lhs, rhs, opts)
			end

			-----------------------------------------------------------
			-- 6.1 Git Hunk 네비게이션 키맵핑
			-----------------------------------------------------------
			-- 다음 변경된 hunk으로 이동
			map("n", "]c", function()
				if vim.wo.diff then
					return "]c"
				end
				vim.schedule(function()
					gs.next_hunk()
				end)
				return "<Ignore>"
			end, { expr = true })

			-- 이전 변경된 hunk으로 이동
			map("n", "[c", function()
				if vim.wo.diff then
					return "[c"
				end
				vim.schedule(function()
					gs.prev_hunk()
				end)
				return "<Ignore>"
			end, { expr = true })
		end,
	})
end

-----------------------------------------------------------
-- 플러그인 반환
-----------------------------------------------------------
return gitsigns_nvim
