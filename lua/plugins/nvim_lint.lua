-----------------------------------------------------------
-- nvim-lint 플러그인 설정 (lazy.nvim 관리)
-----------------------------------------------------------
local nvim_lint = {
	"mfussenegger/nvim-lint", -- 코드 린팅을 위한 플러그인
	config = function()
		-------------------------------------------------------
		-- 1. 파일 유형별 린터 설정
		-------------------------------------------------------
		-- 각 파일 유형에 대해 사용할 린터를 지정합니다.
		-- 예: C 파일은 clangtidy, CMake 파일은 cmakelint, Markdown 파일은 markdownlint 사용
		require("lint").linters_by_ft = {
			c = { "clangtidy" },
			cmake = { "cmakelint" },
			markdown = { "markdownlint" },
		}

		-------------------------------------------------------
		-- 2. 자동 린팅 실행 설정
		-------------------------------------------------------
		-- 파일을 저장(BufWritePost)하거나 읽을 때(BufRead) 린터를 실행하도록 자동 명령을 생성합니다.
		vim.api.nvim_create_autocmd({ "BufWritePost", "BufRead" }, {
			callback = function()
				require("lint").try_lint()
			end,
		})
	end,
}

-----------------------------------------------------------
-- 플러그인 반환
-----------------------------------------------------------
return nvim_lint
