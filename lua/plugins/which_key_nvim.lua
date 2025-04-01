-----------------------------------------------------------
-- which-key.nvim : 키맵 힌트를 제공하는 플러그인
-----------------------------------------------------------
local M = {
	-- 플러그인 리포지토리
	"folke/which-key.nvim",

	-- Lazy.nvim 로드 트리거
	event = "VeryLazy",

	-----------------------------------------------------------
	-- 사용자 설정 (Lazy.nvim에서 M.opts로 전달)
	-----------------------------------------------------------
	opts = {
		-- 여기에 which-key.nvim 설정을 넣을 수 있습니다.
		-- 예) plugins = { spelling = { enabled = true } }
		--
		-- 참고: https://github.com/folke/which-key.nvim#setup
		--
		-- 만약 특별한 설정이 없다면 빈 객체 유지.
	},
}

-----------------------------------------------------------
-- 초기화 함수 (Lazy.nvim에서 plugin.init를 호출)
-----------------------------------------------------------
function M.init()
	-- (1) 입력 대기 시간 설정: 300ms
	-- 만약 <leader> 키 입력 후 300ms 내에 다른 키를 누르지 않으면
	-- 타임아웃이 발생할 수 있음
	vim.o.timeout = true
	vim.o.timeoutlen = 300

	-- (2) 색상 스킴 변경 시점에 WhichKeyValue 하이라이트 적용
	--      (WhichKeyValue는 which-key에서 key-value 표시 부분)
	vim.api.nvim_create_autocmd("ColorScheme", {
		pattern = "*",
		callback = function()
			vim.api.nvim_set_hl(0, "WhichKeyValue", { fg = "#EEEEEE" })
		end,
	})
end

-----------------------------------------------------------
-- (선택) config 함수 정의
-----------------------------------------------------------
-- 만약 which-key의 추가 설정을 위해 require("which-key").setup(...)
-- 호출이 필요하다면, 아래와 같이 config 함수를 작성해줄 수도 있습니다.
-- Lazy.nvim은 M.config를 자동으로 호출함.
-----------------------------------------------------------
-- function M.config()
--   local which_key = require("which-key")
--   which_key.setup(M.opts)
-- end

return M
