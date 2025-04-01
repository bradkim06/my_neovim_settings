-----------------------------------------------------------
-- nvim-lspconfig 플러그인 설정 (lazy.nvim 관리)
-----------------------------------------------------------
local nvim_lspconfig = {
	"neovim/nvim-lspconfig", -- Neovim 내장 LSP 설정 플러그인
	event = "VeryLazy",
	dependencies = {
		"hrsh7th/nvim-cmp", -- 자동 완성 기능
		"williamboman/mason.nvim", -- LSP 서버 설치 및 관리
		"williamboman/mason-lspconfig.nvim", -- mason과 lspconfig 연동
	},
}

-----------------------------------------------------------
-- LSP 서버 목록
-----------------------------------------------------------
local server_list = {
	"neocmake", -- CMake용 LSP
	"clangd", -- C/C++용 LSP
	"jsonls", -- JSON용 LSP
	"lua_ls", -- Lua용 LSP
	"marksman", -- Markdown용 LSP
	"pyright", -- Python용 LSP
	"vimls", -- VimL용 LSP
}

-----------------------------------------------------------
-- nvim-lspconfig 설정 함수
-----------------------------------------------------------
nvim_lspconfig.config = function()
	-- LSP 설정 모듈과 nvim-cmp 통합을 위한 추가 capabilities 설정
	local lspconfig = require("lspconfig")
	local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()

	-------------------------------------------------------
	-- Mason 및 Mason-lspconfig 설정: 지정된 서버 자동 설치
	-------------------------------------------------------
	require("mason").setup()
	require("mason-lspconfig").setup({
		ensure_installed = server_list,
	})

	-------------------------------------------------------
	-- 각 LSP 서버별 개별 설정
	-------------------------------------------------------
	for _, lsp in pairs(server_list) do
		if lsp == "clangd" then
			lspconfig[lsp].setup({
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--completion-style=detailed",
					"--function-arg-placeholders",
					"--fallback-style=llvm",
					"--header-insertion=never",
				},
				filetypes = { "c", "cpp", "cxx", "cc" },
				root_dir = lspconfig.util.root_pattern(".clangd"),
				single_file_support = true,
				capabilities = cmp_capabilities,
			})
		elseif lsp == "neocmake" then
			lspconfig[lsp].setup({
				cmd = { "neocmakelsp", "--stdio" },
				filetypes = { "cmake" },
				root_dir = function(fname)
					return require("lspconfig").util.find_git_ancestor(fname)
				end,
				single_file_support = true, -- 권장 설정
				init_options = {
					format = {
						enable = true,
					},
				},
				capabilities = cmp_capabilities,
			})
		elseif lsp == "pyright" then
			-- Python용 pyright LSP 설정
			lspconfig[lsp].setup({
				capabilities = cmp_capabilities,
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							diagnosticMode = "workspace",
							useLibraryCodeForTypes = true,
						},
					},
				},
			})
		else
			lspconfig[lsp].setup({
				capabilities = cmp_capabilities,
			})
		end
	end

	-------------------------------------------------------
	-- 진단(Diagnostic) 설정
	-------------------------------------------------------
	-- vim.diagnostic.config({
	-- 	virtual_text = false, -- 가상 텍스트를 사용하지 않음 (팝업으로 대체)
	-- 	severity_sort = true, -- 진단을 심각도 순으로 정렬
	-- 	underline = false, -- 밑줄 표시 비활성화
	-- 	float = {
	-- 		border = "rounded", -- 둥근 테두리 사용
	-- 		source = "always", -- 항상 진단 소스 표시
	-- 	},
	-- })

	-------------------------------------------------------
	-- LSP 핸들러 커스터마이징: Hover 및 Signature Help 둥근 테두리 적용
	-------------------------------------------------------
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
	vim.lsp.handlers["textDocument/signatureHelp"] =
		vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
end

-----------------------------------------------------------
-- 플러그인 반환
-----------------------------------------------------------
return nvim_lspconfig
