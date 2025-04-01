-----------------------------------------------------------
-- lspsaga.nvim 플러그인 설정 (lazy.nvim 관리)
-----------------------------------------------------------
local lspsaga_nvim = {
	"nvimdev/lspsaga.nvim", -- LSP 기능 향상을 위한 UI 확장 플러그인
	dependencies = {
		"nvim-treesitter/nvim-treesitter", -- (optional) Treesitter 지원
		"nvim-tree/nvim-web-devicons", -- (optional) 파일 아이콘 제공
	},
	config = function()
		-------------------------------------------------------
		-- lspsaga 기본 설정
		-------------------------------------------------------
		require("lspsaga").setup({
			-- Lightbulb 설정: LSP 코드 액션 제안을 위한 아이콘 표시
			lightbulb = {
				enable = true, -- 기능 활성화
				sign = false, -- 기호(sign) 미표시
				debounce = 10, -- 반응 속도 (ms)
				sign_priority = 40, -- 기호 우선순위
				virtual_text = true, -- 가상 텍스트로 표시
				enable_in_insert = true, -- 입력 모드에서도 활성화
			},

			-- Code Action 설정: 코드 액션 목록 표시 관련 옵션
			code_action = {
				num_shortcut = true, -- 숫자 단축키 활성화
				show_server_name = true, -- 서버 이름 표시
				extend_gitsigns = true, -- gitsigns와 통합하여 추가 정보 표시
				only_in_cursor = false, -- 커서 위치에 국한하지 않음
				max_height = 0.5, -- 창 최대 높이 (비율)
				keys = {
					quit = "q", -- 종료 키
					exec = "<CR>", -- 실행 키 (Enter)
				},
			},

			-- Finder 설정: 정의 및 참조 찾기 기능의 키 매핑
			finder = {
				keys = {
					toggle_or_open = "<CR>", -- Enter로 토글 또는 열기
				},
			},

			-- Rename 설정: 심볼 이름 변경 기능
			rename = {
				in_select = true, -- 선택 영역 내에서 실행
				auto_save = false, -- 자동 저장 비활성화
				project_max_width = 0.5, -- 창 최대 너비 (비율)
				project_max_height = 0.5, -- 창 최대 높이 (비율)
				keys = {
					quit = "<C-c>", -- 취소: Ctrl-C
					exec = "<CR>", -- 실행: Enter
					select = "x", -- 선택: x
				},
			},

			-- UI 설정: 팝업창 및 기타 UI 관련 옵션
			ui = {
				border = "double", -- 팝업창 테두리 스타일 (double)
				-- 필요 시 아래 옵션들을 활성화 할 수 있습니다.
				devicon = true,
				foldericon = true,
				title = true,
				expand = "⊞",
				collapse = "⊟",
				code_action = "💡",
				actionfix = " ",
				lines = { "┗", "┣", "┃", "━", "┏" },
				kind = nil,
				-- imp_sign = "󰳛 ",
			},

			-- 적용 파일 유형: lspsaga 기능을 사용할 파일 종류
			ft = { "c", "cpp", "lua" },
		})

		-------------------------------------------------------
		-- 키 매핑 설정
		-------------------------------------------------------
		local opts = { noremap = true }

		-- 정의(goto definition) 관련 매핑
		vim.keymap.set("n", "gd", "<CMD>Lspsaga goto_definition<CR>", opts)
		vim.keymap.set("n", "gp", "<CMD>Lspsaga peek_definition<CR>", opts)

		-- 정의 및 참조 찾기 매핑
		vim.keymap.set("n", "gr", "<CMD>Lspsaga finder def+ref<CR>", opts)

		-- 터미널 토글 매핑 (일반 및 터미널 모드)
		vim.keymap.set({ "n", "t" }, "<leader>t", "<cmd>Lspsaga term_toggle<cr>", opts)

		-- 심볼 이름 변경(rename) 매핑
		vim.keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<cr>", opts)

		-- 코드 액션 매핑 (일반 및 시각적 모드)
		vim.keymap.set({ "n", "x" }, "<leader>ca", "<cmd>Lspsaga code_action<cr>", opts)

		-- Hover 문서 보기 매핑
		vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<cr>", opts)

		-- 진단(Errors/Warnings) 관련 매핑
		vim.keymap.set("n", "[d", "<CMD>Lspsaga diagnostic_jump_prev<CR>", opts)
		vim.keymap.set("n", "]d", "<CMD>Lspsaga diagnostic_jump_next<CR>", opts)
		vim.keymap.set("n", "gG", "<cmd>Lspsaga show_workspace_diagnostics<cr>", opts)
	end,
}

-----------------------------------------------------------
-- 플러그인 반환
-----------------------------------------------------------
return lspsaga_nvim
