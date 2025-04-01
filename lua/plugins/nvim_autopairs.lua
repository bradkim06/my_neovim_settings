-----------------------------------------------------------
-- nvim-autopairs 플러그인 설정 (lazy.nvim 관리)
-----------------------------------------------------------
local nvim_autopairs = {
	"windwp/nvim-autopairs", -- 자동 괄호, 따옴표 등 짝 문자를 자동 완성해주는 플러그인
	event = "InsertEnter", -- 입력 모드 진입 시 로드
	opts = {}, -- 기본 옵션 (setup({})와 동일)
}

-----------------------------------------------------------
-- 플러그인 설정 함수
-----------------------------------------------------------
nvim_autopairs.config = function()
	-------------------------------------------------------
	-- 1. nvim-autopairs 기본 모듈 불러오기
	-------------------------------------------------------
	local autopairs_setup, autopairs = pcall(require, "nvim-autopairs")
	if not autopairs_setup then
		return
	end

	-------------------------------------------------------
	-- 2. nvim-autopairs 기본 설정 적용
	-------------------------------------------------------
	autopairs.setup({
		check_ts = true, -- Treesitter를 사용하여 구문 트리 기반 자동완성 활성화
		ts_config = {
			-- lua 파일: 문자열 내에서는 자동 괄호 추가하지 않음
			lua = { "string" },
			-- JavaScript 파일: template_string 노드에서는 자동 괄호 추가하지 않음
			javascript = { "template_string" },
			-- Java 파일: Treesitter 검사를 비활성화
			java = false,
		},
		-- 자동완성을 비활성화할 파일 타입
		disable_filetype = { "TelescopePrompt", "spectre_panel" },
	})

	-------------------------------------------------------
	-- 3. nvim-autopairs와 nvim-cmp 연동 (자동완성과 괄호 매칭 통합)
	-------------------------------------------------------
	-- 3.1. nvim-autopairs의 cmp 모듈 안전하게 불러오기
	local cmp_autopairs_setup, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
	if not cmp_autopairs_setup then
		return
	end

	-- 3.2. nvim-cmp(completion) 모듈 안전하게 불러오기
	local cmp_setup, cmp = pcall(require, "cmp")
	if not cmp_setup then
		return
	end

	-- 3.3. nvim-cmp의 confirm_done 이벤트에 autopairs의 on_confirm_done 연결
	cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

-----------------------------------------------------------
-- 플러그인 반환
-----------------------------------------------------------
return nvim_autopairs
