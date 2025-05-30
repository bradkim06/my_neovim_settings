-----------------------------------------------------------
-- markdown-preview.nvim 플러그인 설정 (lazy.nvim 관리)
-----------------------------------------------------------
local markdown_preview_nvim = {
	"iamcco/markdown-preview.nvim", -- 마크다운 미리보기 플러그인
	-------------------------------------------------------
	-- 플러그인 로드 조건
	-------------------------------------------------------
	-- 아래 명령어 실행 시 플러그인을 로드합니다.
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	-- 마크다운 파일(ft) 열릴 때도 플러그인을 로드하도록 설정합니다.
	ft = { "markdown" },

	-------------------------------------------------------
	-- 빌드 및 초기 설정
	-------------------------------------------------------
	-- 플러그인 설치 후, 'app' 디렉토리로 이동하여 yarn install을 실행합니다.
	build = "cd app && yarn install",
	init = function()
		-- 마크다운 파일에 대해서만 미리보기 기능을 활성화합니다.
		vim.g.mkdp_filetypes = { "markdown" }
	end,
}

-----------------------------------------------------------
-- 플러그인 반환
-----------------------------------------------------------
return markdown_preview_nvim
