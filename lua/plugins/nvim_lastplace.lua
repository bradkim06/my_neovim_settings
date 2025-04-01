-----------------------------------------------------------
-- nvim-lastplace: 이전 편집 위치로 커서를 복원해주는 플러그인
-----------------------------------------------------------
local M = {
	"ethanholz/nvim-lastplace", -- 플러그인 경로
	event = "BufRead", -- 파일을 읽을 때 로드
}

-----------------------------------------------------------
-- 플러그인 설정 함수
-----------------------------------------------------------
function M.config()
	require("nvim-lastplace").setup({
		-- 무시할 buftype 목록
		lastplace_ignore_buftype = { "quickfix", "nofile", "help" },

		-- 무시할 filetype 목록
		lastplace_ignore_filetype = {
			"gitcommit",
			"gitrebase",
			"svn",
			"hgcommit",
		},

		-- 폴드를 열어둔 상태로 마지막 위치로 이동
		lastplace_open_folds = true,
	})
end

return M
