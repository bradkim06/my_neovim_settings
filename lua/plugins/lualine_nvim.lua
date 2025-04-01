-----------------------------------------------------------
-- lualine.nvim 플러그인 설정 (lazy.nvim 관리)
-----------------------------------------------------------
local lualine_nvim = {
	"nvim-lualine/lualine.nvim", -- Neovim 상태줄 플러그인
	dependencies = { "nvim-tree/nvim-web-devicons" }, -- 아이콘 제공 플러그인
	event = "VeryLazy", -- 매우 느슨한(lazy) 시점에 로드
}

-----------------------------------------------------------
-- lualine 설정 옵션
-----------------------------------------------------------
lualine_nvim.opts = {
	-------------------------------------------------------
	-- 1. 전체 옵션 설정
	-------------------------------------------------------
	options = {
		icons_enabled = true, -- 아이콘 사용 여부
		theme = "tokyonight", -- 사용 테마 (tokyonight)
		component_separators = { left = "", right = "" }, -- 컴포넌트 구분자
		section_separators = { left = "", right = "" }, -- 섹션 구분자
		disabled_filetypes = {
			statusline = {}, -- 상태줄에서 제외할 파일 타입 (빈 테이블: 없음)
			winbar = {},
		},
		ignore_focus = {}, -- 포커스 무시할 파일 타입
		always_divide_middle = true, -- 중앙 구분자 항상 표시
		globalstatus = false, -- 글로벌 상태줄 사용 여부 (Neovim 0.7 이상)
		refresh = {
			statusline = 1000, -- 상태줄 갱신 간격 (ms)
			tabline = 1000, -- 탭라인 갱신 간격 (ms)
			winbar = 1000, -- winbar 갱신 간격 (ms)
		},
	},

	-------------------------------------------------------
	-- 2. 활성 상태줄 섹션 설정
	-------------------------------------------------------
	sections = {
		lualine_a = { "mode" }, -- 모드 표시 (예: INSERT, NORMAL 등)
		lualine_b = { "branch", "diff", "diagnostics" }, -- Git 브랜치, diff, 진단 정보
		lualine_c = { "filename" }, -- 현재 파일명 표시
		lualine_x = { "encoding", "fileformat", "filetype" }, -- 파일 인코딩, 파일 포맷, 파일 타입
		lualine_y = { "progress" }, -- 진행률 (파일 내 위치)
		lualine_z = { "location" }, -- 커서 위치 (행, 열)
	},

	-------------------------------------------------------
	-- 3. 비활성 상태줄 섹션 설정
	-------------------------------------------------------
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" }, -- 비활성 버퍼에서도 파일명 표시
		lualine_x = { "location" }, -- 비활성 상태에서도 위치 표시
		lualine_y = {},
		lualine_z = {},
	},

	-------------------------------------------------------
	-- 4. 추가 영역 설정 (탭라인, winbar 등)
	-------------------------------------------------------
	tabline = {}, -- 탭라인 설정 (추가 커스터마이징 가능)
	winbar = {}, -- 활성 winbar 설정
	inactive_winbar = {}, -- 비활성 winbar 설정
	extensions = {}, -- 확장 플러그인 (예: NvimTree, ToggleTerm 등)
}

-----------------------------------------------------------
-- 플러그인 반환
-----------------------------------------------------------
return lualine_nvim
