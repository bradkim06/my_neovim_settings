-----------------------------------------------------------
-- nvim-cmp : 자동완성 플러그인
-----------------------------------------------------------
local M = {
	"hrsh7th/nvim-cmp",
	event = { "InsertEnter" }, -- 입력 모드 진입 시 로드

	dependencies = {
		"neovim/nvim-lspconfig",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		-- LuaSnip 연동
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",

		-- 아이콘/심볼(디버깅 편) & 자동 괄호 보완
		"onsails/lspkind.nvim",
		"windwp/nvim-autopairs",
	},
}

-----------------------------------------------------------
-- 플러그인 설정 함수
-----------------------------------------------------------
function M.config()
	-- (1) nvim-cmp 관련 설정
	-- (2) 루아 스니펫 (LuaSnip) 연동
	-- (3) cmdline (/, :) 자동완성 지원
	-- (4) autopairs 연동

	-----------------------------------------------------------
	-- 1. Neovim 옵션: completeopt
	-----------------------------------------------------------
	--   menu     : 자동완성 메뉴 표시
	--   menuone  : 후보가 하나라도 메뉴 표시
	--   noselect : 기본 선택이 없음
	-----------------------------------------------------------
	vim.opt.completeopt = { "menu", "menuone", "noselect" }

	local cmp = require("cmp")

	-----------------------------------------------------------
	-- 헬퍼 함수: 커서 앞에 공백이 아닌 문자가 있는지 확인
	-----------------------------------------------------------
	local has_words_before = function()
		-- Lua 5.2 이상의 table.unpack 호환
		local unpack = unpack or table.unpack
		local line, col = unpack(vim.api.nvim_win_get_cursor(0))
		local text = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1] or ""
		return (col ~= 0) and (text:sub(col, col):match("%s") == nil)
	end

	local luasnip = require("luasnip")

	-----------------------------------------------------------
	-- 2. nvim-cmp 설정 (기본)
	-----------------------------------------------------------
	cmp.setup({
		---------------------------------------------------------
		-- 스니펫 설정 (LuaSnip 사용)
		---------------------------------------------------------
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},

		---------------------------------------------------------
		-- window : cmp의 보더 등 UI 설정
		---------------------------------------------------------
		window = {
			completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
		},

		---------------------------------------------------------
		-- sources : 자동완성 소스
		--   path       : 파일 경로
		--   nvim_lsp   : LSP 서버
		--   buffer     : 현재 버퍼에서 단어 추출
		--   luasnip    : snippet 확장
		---------------------------------------------------------
		sources = {
			{ name = "path" },
			{ name = "nvim_lsp", keyword_length = 1 },
			{ name = "buffer", keyword_length = 3 },
			{ name = "luasnip", keyword_length = 2 },
		},

		---------------------------------------------------------
		-- formatting : lspkind 등 사용해 아이콘/심볼 표시
		---------------------------------------------------------
		formatting = {
			fields = { "abbr", "kind", "menu" },
			format = require("lspkind").cmp_format({
				mode = "symbol_text",
				menu = {
					path = "[Path]",
					nvim_lsp = "[LSP]",
					buffer = "[Buffer]",
					luasnip = "[LuaSnip]",
				},
			}),
		},

		---------------------------------------------------------
		-- mapping : 입력/단축키 매핑
		---------------------------------------------------------
		mapping = cmp.mapping.preset.insert({
			-- 스크롤 (문서/도큐멘테이션)
			["<C-u>"] = cmp.mapping.scroll_docs(-4),
			["<C-d>"] = cmp.mapping.scroll_docs(4),

			-- 수동으로 completion 열기
			["<C-Space>"] = cmp.mapping.complete(),

			-- <C-c> : 자동완성 중단/취소
			["<C-c>"] = cmp.mapping.abort(),

			-------------------------------------------------------
			-- <CR> : 엔터 시, visible하고 active entry가 있으면 confirm
			-------------------------------------------------------
			["<CR>"] = cmp.mapping({
				i = function(fallback)
					if cmp.visible() and cmp.get_active_entry() then
						cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
					else
						fallback()
					end
				end,
				s = cmp.mapping.confirm({ select = true }),
				c = cmp.mapping.confirm({ select = false }),
			}),

			-------------------------------------------------------
			-- <C-f> / <C-b> : luasnip forward/backward jump
			-------------------------------------------------------
			["<C-f>"] = cmp.mapping(function(fallback)
				if luasnip.jumpable(1) then
					luasnip.jump(1)
				else
					fallback()
				end
			end, { "i", "s" }),

			["<C-b>"] = cmp.mapping(function(fallback)
				if luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, { "i", "s" }),

			-------------------------------------------------------
			-- <Tab> : 다음 아이템, 또는 luasnip 확장/점프, 또는 자동완성 호출
			-------------------------------------------------------
			["<Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					-- 후보가 1개면 바로 confirm
					if #cmp.get_entries() == 1 then
						cmp.confirm({ select = true })
					else
						cmp.select_next_item()
					end
				elseif luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				elseif has_words_before() then
					cmp.complete()
					if #cmp.get_entries() == 1 then
						cmp.confirm({ select = true })
					end
				else
					fallback()
				end
			end, { "i", "s" }),

			-- <S-Tab> : 이전 아이템 선택, 또는 snippet 역점프
			["<S-Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, { "i", "s" }),
		}),
	})

	-----------------------------------------------------------
	-- 3. cmdline 설정
	--    (/, :) 등 cmdline 모드에서도 자동완성
	-----------------------------------------------------------
	-- (a) '/' cmdline => 버퍼 검색
	cmp.setup.cmdline("/", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = "buffer" },
		},
	})

	-- (b) ':' cmdline => path, cmdline
	cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = "path" },
		}, {
			{
				name = "cmdline",
				option = {
					ignore_cmds = { "Man" },
				},
			},
		}),
	})

	-----------------------------------------------------------
	-- 4. autopairs 연동 (옵션)
	-----------------------------------------------------------
	-- local cmp_autopairs = require("nvim-autopairs.completion.cmp")
	-- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

	-----------------------------------------------------------
	-- (추가) 만약 LSP 설정과 연동하려면:
	-----------------------------------------------------------
	-- local capabilities = require("cmp_nvim_lsp").default_capabilities()
	-- require("lspconfig")["pyright"].setup({
	--   capabilities = capabilities,
	-- })
	-----------------------------------------------------------
	-- 위와 같이 LSP 서버 설정 시 capabilities를 연결해주면
	-- nvim-cmp가 LSP 자동완성을 제대로 활용할 수 있음.
end

return M
