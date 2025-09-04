-----------------------------------------------------------
-- Lazy.nvim 플러그인 매니저 설정 및 플러그인 목록 (VSCode용)
-----------------------------------------------------------

-- lazy.nvim 설치 로직 (기존과 동일)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-----------------------------------------------------------
-- 2. 플러그인 목록 및 설정 (VSCode 최적화)
-----------------------------------------------------------
require("lazy").setup({
	-------------------------------------------------------------------------
	-- 코드 편집 및 도구 관련 플러그인
	-------------------------------------------------------------------------
	require("plugins.conform_nvim"), -- 코드 자동 포맷팅
	require("plugins.nvim_treesitter"), -- Tree-sitter 기반 문법 강조
	require("plugins.comment_nvim"), -- 주석 추가/삭제
	require("plugins.todo-comments_nvim"), -- TODO 코멘트 하이라이트
	require("plugins.nvim_lastplace"), -- 마지막 편집 위치 복원
	require("plugins.sniprun"), -- 코드 스니펫 실행
	require("plugins.nvim_surround"), -- 둘러싸기 연산 지원
	require("plugins.nvim_cmp"), -- 자동 완성
	require("plugins.neogen"), -- 문서 주석 자동 생성
	require("plugins.nvim_lint"), -- 코드 린팅

	-------------------------------------------------------------------------
	-- 플러그인 설치만 필요한 항목
	-------------------------------------------------------------------------
	"tpope/vim-sensible", -- 기본적인 Vim 설정 제공
})
