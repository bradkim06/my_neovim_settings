-----------------------------------------------------------
-- wilder.nvim 플러그인 설정 (lazy.nvim 관리)
-----------------------------------------------------------
local wilder_nvim = {
	"gelguy/wilder.nvim", -- 명령줄 및 검색 인터페이스 향상을 위한 플러그인
	event = "VeryLazy", -- 매우 느슨한(lazy) 시점에 로드
	dependencies = {
		"romgrk/fzy-lua-native",
		"nixprime/cpsm",
		"sharkdp/fd",
		"nvim-tree/nvim-web-devicons",
	},
}

-----------------------------------------------------------
-- 플러그인 설정 함수
-----------------------------------------------------------
wilder_nvim.config = function()
	local wilder = require("wilder")

	-- wilder 기본 설정: 명령 모드, 검색, 대체 모드 등에서 활성화
	wilder.setup({ modes = { ":", "/", "?" } })

	-----------------------------------------------------------
	-- Pipeline 설정: wilder의 입력 파이프라인 구성
	-----------------------------------------------------------
	wilder.set_option("pipeline", {
		wilder.branch(
			--[[
            -- 파일 찾기 파이프라인 예제 (현재는 주석 처리)
            wilder.python_file_finder_pipeline({
                file_command = function(ctx, arg)
                    if string.find(arg, ".") ~= nil then
                        return { "fd", "-tf", "-H" }
                    else
                        return { "fd", "-tf" }
                    end
                end,
                dir_command = { "fd", "-td" },
                filters = { "fuzzy_filter", "difflib_sorter" },
            }),
            --]]
			-- 대체(substitute) 파이프라인: 검색 기능 강화
			wilder.substitute_pipeline({
				pipeline = wilder.python_search_pipeline({
					skip_cmdtype_check = 1,
					pattern = wilder.python_fuzzy_pattern({ start_at_boundary = 0 }),
				}),
			}),
			-- 명령줄(cmdline) 파이프라인: fuzzy 검색 및 필터링
			wilder.cmdline_pipeline({
				fuzzy = 2,
				fuzzy_filter = wilder.lua_fzy_filter(),
			}),
			-- 빈 입력일 경우, 히스토리 사용
			{
				wilder.check(function(ctx, x)
					return x == ""
				end),
				wilder.history(),
			},
			-- 기본 Python 검색 파이프라인: fuzzy 패턴과 정렬 기능 사용
			wilder.python_search_pipeline({
				pattern = wilder.python_fuzzy_pattern(),
				sorter = wilder.python_difflib_sorter(),
				engine = "re2", -- 성능 향상을 위해 re2 엔진 사용 (pyre2 필요)
			})
		),
	})

	-----------------------------------------------------------
	-- Highlighters 설정: 검색 결과 하이라이팅 기능
	-----------------------------------------------------------
	local highlighters = {
		wilder.pcre2_highlighter(),
		wilder.lua_fzy_highlighter(),
	}

	-----------------------------------------------------------
	-- Popupmenu Renderer 설정: 검색 결과 표시 UI 구성
	-----------------------------------------------------------
	local popupmenu_renderer = wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
		border = "rounded", -- 둥근 테두리
		max_height = "90%", -- 팝업 최대 높이 (비율)
		min_height = 0, -- 최소 높이 (0이면 자동 조절)
		prompt_position = "bottom", -- 프롬프트 위치: 하단
		reverse = 0, -- 목록 순서 반전 여부 (0: 기본 순서)
		highlighter = highlighters, -- 적용할 하이라이터
		highlights = {
			accent = wilder.make_hl("WilderAccent", "Pmenu", { { a = 1 }, { a = 1 }, { foreground = "#f4468f" } }),
		},
		left = {
			" ",
			wilder.popupmenu_devicons(), -- 파일 아이콘 표시
		},
		right = {
			" ",
			wilder.popupmenu_scrollbar(), -- 스크롤바 표시
		},
	}))

	-----------------------------------------------------------
	-- Renderer 설정: 모드에 따른 적절한 렌더러 적용
	-----------------------------------------------------------
	wilder.set_option(
		"renderer",
		wilder.renderer_mux({
			[":"] = popupmenu_renderer,
			["/"] = popupmenu_renderer,
			substitute = popupmenu_renderer,
		})
	)
end

-----------------------------------------------------------
-- 플러그인 반환
-----------------------------------------------------------
return wilder_nvim
