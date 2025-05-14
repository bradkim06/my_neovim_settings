-----------------------------------------------------------
-- Lazy.nvim 플러그인 매니저 설정 및 플러그인 목록
-----------------------------------------------------------

--[[
  1. lazy.nvim 설치
  lazy.nvim은 Neovim의 플러그인 로딩 속도를 최적화하기 위해 사용되는 플러그인 매니저입니다.
  아래 코드는 lazy.nvim이 설치되어 있지 않으면 Git을 통해 자동으로 클론하고,
  runtime path의 최상단에 추가하는 역할을 합니다.
--]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none", -- 불필요한 blob 데이터 제외
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- 최신 안정화 버전 사용
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath) -- lazy.nvim을 runtime path의 가장 앞에 추가

-----------------------------------------------------------
-- 2. 플러그인 목록 및 설정
-----------------------------------------------------------
-- lazy.nvim의 setup 함수에 플러그인 목록을 전달합니다.
-- 아래 목록은 실험적 플러그인부터 컬러스킴, 코드 관련 도구, LSP 등 다양한 용도로 사용되는 플러그인들로 구성되어 있습니다.
require("lazy").setup({
	-------------------------------------------------------------------------
	-- Experimental Plugin (실험적 플러그인)
	-------------------------------------------------------------------------

	-------------------------------------------------------------------------
	-- Colorscheme 및 테마 설정
	-------------------------------------------------------------------------
	"catppuccin/nvim", -- Catppuccin 테마
	require("plugins.colorscheme"), -- 별도 파일에서 추가 색상 설정 불러오기

	-------------------------------------------------------------------------
	-- 코드 편집 및 도구 관련 플러그인
	-------------------------------------------------------------------------
	require("plugins.conform_nvim"), -- 코드 자동 포맷팅 (Conform)
	require("plugins.gitsigns_nvim"), -- Git 변경사항 표시
	require("plugins.lazygit_nvim"), -- Neovim 내에서 lazygit 터미널 UI
	require("plugins.bufferline_nvim"), -- 버퍼라인(탭) 플러그인
	require("plugins.nvim_treesitter"), -- Tree-sitter 기반 문법 강조 및 코드 네비게이션
	require("plugins.comment_nvim"), -- 주석 추가/삭제 플러그인
	require("plugins.lualine_nvim"), -- 상태줄(라인) 플러그인
	require("plugins.todo-comments_nvim"), -- todo 코멘트 하이라이트
	require("plugins.markdown-preview_nvim"), -- markdown previewer

	require("plugins.nvim_colorizer_lua"), -- 코드 내 색상 문자열 시각화
	require("plugins.nvim_lastplace"), -- 마지막 편집 위치 복원
	require("plugins.telescope_nvim"), -- 강력한 파일 및 심볼 검색
	require("plugins.sniprun"), -- 코드 스니펫 실행 플러그인
	require("plugins.which_key_nvim"), -- 키 바인딩 도움말 팝업
	require("plugins.nvim_surround"), -- 둘러싸기 연산 지원 플러그인
	require("plugins.nvim_cmp"), -- 자동 완성 플러그인
	require("plugins.nvim_autopairs"), -- 자동 괄호, 따옴표 매칭
	require("plugins.neogen"), -- 문서 주석 자동 생성
	require("plugins.nvim_lint"), -- 코드 린팅 플러그인
	require("plugins.toggleterm"),

	-------------------------------------------------------------------------
	-- LSP (Language Server Protocol) 관련 플러그인
	-------------------------------------------------------------------------
	require("plugins.nvim_lspconfig"), -- LSP 서버 설정 및 관리
	-- require("plugins.trouble_nvim"),
	-- require("plugins.lspsaga_nvim"), -- LSP 확장 기능 및 UI 개선

	-------------------------------------------------------------------------
	-- 플러그인 설치만 필요한 항목
	-------------------------------------------------------------------------
	"tpope/vim-sensible", -- 기본적인 Vim 설정 제공
	"sindrets/diffview.nvim", -- Git diff 보기 및 내비게이션

	-------------------------------------------------------------------------
	-- 사용하지 않는 플러그인 (Unused Now)
	-------------------------------------------------------------------------
	--[[
    require("plugins.navigator_lua"),  -- 네비게이션 플러그인
	require("plugins.wilder_nvim"), -- 검색 및 치환 기능 강화 플러그인
    require("plugins.compiler_nvim"),  -- 컴파일러 관련 플러그인 (필요시 활성화)
    require("plugins.nvim_spectre"),    -- 다중 파일 검색 및 치환 (필요시 활성화)
	require("plugins.trouble_nvim"),
    --]]
})
