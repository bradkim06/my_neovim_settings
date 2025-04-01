-----------------------------------------------------------
-- Trouble.nvim 플러그인 설정 (lazy.nvim 관리)
-----------------------------------------------------------
local trouble_nvim = {
	"folke/trouble.nvim", -- LSP 진단, quickfix, loclist 등 다양한 목록 UI를 제공하는 플러그인
	opts = {}, -- 기본 옵션 사용 (필요시 Trouble.nvim 문서를 참고하여 옵션을 추가할 수 있습니다)
	cmd = "Trouble", -- :Trouble 명령어 실행 시 플러그인이 로드됨
	keys = {
		{
			"<leader>xx",
			"<cmd>Trouble diagnostics toggle<cr>",
			desc = "Toggle Diagnostics List (Trouble)",
		},
		{
			"<leader>xX",
			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
			desc = "Toggle Buffer Diagnostics (Trouble)",
		},
		{
			"<leader>cs",
			"<cmd>Trouble symbols toggle focus=false<cr>",
			desc = "Toggle Symbols List (Trouble)",
		},
		{
			"<leader>cl",
			"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
			desc = "Toggle LSP Info (Definitions / References / etc.) (Trouble)",
		},
		{
			"<leader>xL",
			"<cmd>Trouble loclist toggle<cr>",
			desc = "Toggle Location List (Trouble)",
		},
		{
			"<leader>xQ",
			"<cmd>Trouble qflist toggle<cr>",
			desc = "Toggle Quickfix List (Trouble)",
		},
	},
}

-----------------------------------------------------------
-- 플러그인 반환
-----------------------------------------------------------
return trouble_nvim
