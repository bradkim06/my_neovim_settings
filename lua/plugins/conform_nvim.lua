-----------------------------------------------------------
-- conform.nvim 플러그인 설정 (lazy.nvim 관리)
-----------------------------------------------------------
local conform_nvim = {
	"stevearc/conform.nvim", -- 포매터 관리 플러그인
	opts = {},
}

-----------------------------------------------------------
-- 플러그인 설정 함수
-----------------------------------------------------------
conform_nvim.config = function()
	require("conform").setup({
		-----------------------------------------------------------
		-- 1. 파일 타입별 포매터 설정
		-----------------------------------------------------------
		formatters_by_ft = {
			-- C 및 C++ 파일에 clang_format 사용
			c = { "clang_format" },
			cpp = { "clang_format" },
			-- CMake 파일에 cmake_format 사용
			cmake = { "cmake_format" },
			-- 쉘 스크립트 파일에 shfmt 사용 (sh filetype)
			sh = { "shfmt" },
			-- Lua 파일에 stylua 사용
			lua = { "stylua" },
			-- Python 파일: ruff_format이 사용 가능한 경우 사용, 아니면 isort와 black 조합 사용
			python = { "ruff" },
			-- Markdown 파일에 mdformat 사용
			markdown = { "mdformat" },
			-- JSON 및 JSONC 파일에 prettierd 사용
			json = { "prettierd" },
			jsonc = { "prettierd" },
			-- "_" 파일 타입: 별도의 포매터가 없는 파일에 대해 trim_whitespace 실행
			["_"] = { "trim_whitespace" },
			-- 추가: bash 파일에 shfmt 사용
			bash = { "shfmt" },
			-- 추가: zsh 파일에 shfmt 사용
			zsh = { "shfmt" },
		},

		-----------------------------------------------------------
		-- 2. 저장 후 자동 포맷 설정
		-----------------------------------------------------------
		format_on_save = {
			lsp_fallback = true,
			async = false, -- ← 동기화
		},

		-----------------------------------------------------------
		-- 3. 로그 및 에러 알림 설정
		-----------------------------------------------------------
		log_level = vim.log.levels.ERROR,
		notify_on_error = true,
	})
end

-----------------------------------------------------------
-- conform.nvim 플러그인 반환
-----------------------------------------------------------
return conform_nvim
