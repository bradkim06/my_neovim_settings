-----------------------------------------------------------
-- nvim-treesitter : 고성능 구문 분석 / 하이라이트
-----------------------------------------------------------
local M = {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate", -- 설치 후 모든 파서 업데이트
	event = "VeryLazy", -- "매우 느슨한(lazy)" 시점에 로드
	dependencies = {
		-- 괄호/태그 컬러링 등
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
}

-----------------------------------------------------------
-- 플러그인 설정 함수
-----------------------------------------------------------
function M.config()
	-----------------------------------------------------------
	-- nvim-treesitter.configs : Treesitter 관련 설정
	-----------------------------------------------------------


	require("nvim-treesitter.configs").setup({
		---------------------------------------------------------
		-- 어떤 파서(언어)를 설치할지
		---------------------------------------------------------
		-- "all"로 두면 지원되는 파서를 전부 설치하지만, 필요 없는 언어가 너무 많을 수도 있음.
		-- 필요하다면 { "c", "cpp", "lua", ... } 등 원하는 목록을 지정 가능.
		ensured_installed = {
			"bash",
			"comment",
			"lua",
			"markdown",
			"regex",
			"yaml",
			"lua",
			"c",
			"cpp",
			"python",
			"arduino",
			"markdown_inline",
			"vim",
			"vimdoc",
		},
		sync_install = false, -- 동기 설치 비활성화(=비동기 설치)
		auto_install = true, -- 누락된 파서 자동 설치

		---------------------------------------------------------
		-- 하이라이트(highlight)
		---------------------------------------------------------
		highlight = {
			enable = true, -- 구문 하이라이트 기능 활성화
			-- disable = { "lua" }, -- 특정 언어 비활성화 예시
			-- additional_vim_regex_highlighting = false,
		},

		---------------------------------------------------------
		-- rainbow : 괄호/태그 색깔 구분
		---------------------------------------------------------
		rainbow = {
			enable = true, -- 레인보우 기능 활성화
			extended_mode = true, -- 괄호 외에도 HTML 태그 등 구분
			max_file_lines = nil, -- 파일 크기에 관계없이 적용
			-- colors = { "#ffd700", "#da70d6", "#87cefa" }, -- 사용자 지정 색 예시
			-- termcolors = { "Yellow", "Magenta", "Cyan" },
		},

		---------------------------------------------------------
		-- (옵션) incremental_selection 등 다른 기능 예시
		---------------------------------------------------------
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "gnn", -- 노멀 모드에서 gnn으로 노드 선택 시작
				node_incremental = "grn", -- 노드 단위로 확장
				scope_incremental = "grc", -- scope 단위로 확장
				node_decremental = "grm", -- 축소
			},
		},

		textobjects = {
			select = {
				enable = true,
				lookahead = true, -- 다음 텍스트 객체를 미리 인식
				keymaps = {
					["af"] = "@function.outer", -- 함수 범위(전체)
					["if"] = "@function.inner", -- 함수 내부
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
				},
			},
		},
	})

	-----------------------------------------------------------
	-- LSP 주석 하이라이트 링크 설정
	-----------------------------------------------------------
	local function link_comment()
		---------------------------------------------------------
		-- C/C++ 언어에서 LSP가 주석 토큰을 따로 분류할 경우,
		-- @lsp.type.comment.* 하이라이트를 기본 Comment로 연결
		---------------------------------------------------------
		vim.api.nvim_set_hl(0, "@lsp.type.comment.c", { link = "Comment" })
		vim.api.nvim_set_hl(0, "@lsp.type.comment.cpp", { link = "Comment" })
	end

	-- 처음 로드시 한 번 실행
	link_comment()

	-- ColorScheme 변경 때마다 재설정
	vim.api.nvim_create_autocmd("ColorScheme", {
		callback = link_comment,
	})

end

-----------------------------------------------------------
-- 추가 팁 / 확장 아이디어
-----------------------------------------------------------
-- 1) nvim-treesitter-textobjects :
--    함수나 클래스 등 구문 단위로 객체를 인식, "af", "if" 등으로 쉽게 선택/이동 가능.
--    위 incremental_selection, textobjects 예시를 함께 참고.
--
-- 2) nvim-ts-autotag :
--    HTML/JSX 태그 자동 닫힘, rename 등.
--
-- 3) context_commentstring 연동 :
--    Treesitter 구문 기반으로 주석문자를 자동 추론(예: vue/jsx에서 script vs template)
--    https://github.com/JoosepAlviste/nvim-ts-context-commentstring
--
-- 4) playground :
--    nvim-treesitter/playground : 구문 트리를 시각적으로 확인 가능. 디버깅/학습 시 유용.
--
-- 5) 성능 주의 :
--    "ensure_installed = 'all'" 시 매우 많은 언어 파서를 설치.
--    원하는 언어만 { ... }로 지정해 빌드 시간을 줄일 수 있음.

return M
