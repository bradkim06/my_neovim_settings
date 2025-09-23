-----------------------------------------------------------
-- nvim-lspconfig (lazy.nvim)
-----------------------------------------------------------
local nvim_lspconfig = {
	"neovim/nvim-lspconfig",
	event = "VeryLazy",
	dependencies = {
		"hrsh7th/nvim-cmp",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
}

-----------------------------------------------------------
-- LSP 서버 목록
-----------------------------------------------------------
local servers = {
	"neocmake",
	"clangd",
	"jsonls",
	"lua_ls",
	"marksman",
	"pyright",
	"vimls",
	"arduino_language_server",
}

-----------------------------------------------------------
-- 플러그인 설정
-----------------------------------------------------------
nvim_lspconfig.config = function()
	----------------------------------------------------------------
	-- 기본
	----------------------------------------------------------------
	local capabilities = require("cmp_nvim_lsp").default_capabilities()

	-- arduino 파일타입 추가
	vim.filetype.add({ extension = { ino = "arduino" } })

	-- 루트 디렉토리 헬퍼 (vim.fs 기반)
	local function root_with(markers, fallback_to_cwd)
		return function(fname)
			local found = vim.fs.find(markers, { upward = true, path = fname })[1]
			if found then
				return vim.fs.dirname(found)
			end
			return fallback_to_cwd and vim.loop.cwd() or nil
		end
	end

	----------------------------------------------------------------
	-- mason (설치만 책임)
	----------------------------------------------------------------
	require("mason").setup()

	-- mason-lspconfig: ensure_installed만 사용 (자동 enable은 직접)
	require("mason-lspconfig").setup({
		ensure_installed = servers,
	})

	----------------------------------------------------------------
	-- 한 군데에서만 enable (신규 API)
	-- 1) vim.lsp.config('<name>', { ...옵션... })
	-- 2) vim.lsp.enable('<name>')
	----------------------------------------------------------------
	local function enable_with(name, opts)
		opts = opts or {}
		-- 공통 capabilities 주입
		opts.capabilities = vim.tbl_deep_extend("force", { capabilities = capabilities }, opts or {})
		vim.lsp.config(name, opts)
		vim.lsp.enable(name)
	end

	-- clangd: 커스텀 옵션
	enable_with("clangd", {
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
		-- .clangd 또는 .git 기준으로 루트 탐색
		root_dir = root_with({ ".clangd", ".git" }, true),
		single_file_support = true,
	})

	-- neocmake
	enable_with("neocmake", {
		cmd = { "neocmakelsp", "--stdio" },
		filetypes = { "cmake" },
		root_dir = root_with({ ".git" }, true),
		single_file_support = true,
		init_options = { format = { enable = true } },
	})

	-- pyright
	enable_with("pyright", {
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

	-- arduino_language_server
	enable_with("arduino_language_server", {
		cmd = {
			"arduino-language-server",
			"-cli",
			"arduino-cli",
			"-clangd",
			"clangd",
			"-cli-config",
			vim.fn.expand("~/.config/arduino-cli/arduino-cli.yaml"),
			"-fqbn",
			"esp32:esp32:esp32c3",
		},
		filetypes = { "arduino" },
		root_dir = root_with({ ".git" }, true),
		single_file_support = true,
	})

	-- 나머지 서버는 공통 옵션만
	local custom = {
		clangd = true,
		neocmake = true,
		pyright = true,
		arduino_language_server = true,
	}
	for _, server in ipairs(servers) do
		if not custom[server] then
			enable_with(server, {}) -- capabilities만 주입
		end
	end

	----------------------------------------------------------------
	-- 진단 UI
	----------------------------------------------------------------
	vim.diagnostic.config({
		virtual_text = false,
		severity_sort = true,
		underline = false,
		float = { border = "rounded", source = "always" },
	})

	----------------------------------------------------------------
	-- hover / signatureHelp UI
	----------------------------------------------------------------
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

	vim.lsp.handlers["textDocument/signatureHelp"] =
		vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
end

return nvim_lspconfig
