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
	local lspconfig = require("lspconfig")
	local capabilities = require("cmp_nvim_lsp").default_capabilities()

	vim.filetype.add({ extension = { ino = "arduino" } })

	----------------------------------------------------------------
	-- mason
	----------------------------------------------------------------
	require("mason").setup()

	-- ✱ 자동-setup 끄고, ensure_installed 만 사용
	require("mason-lspconfig").setup({
		ensure_installed = servers,
		handlers = {}, -- ← 핵심: mason이 setup() 안 함
	})

	----------------------------------------------------------------
	-- 한 군데에서만 setup
	----------------------------------------------------------------
	for _, server in ipairs(servers) do
		if server == "clangd" then
			lspconfig.clangd.setup({
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
				capabilities = capabilities,
			})
		elseif server == "neocmake" then
			lspconfig.neocmake.setup({
				cmd = { "neocmakelsp", "--stdio" },
				filetypes = { "cmake" },
				root_dir = lspconfig.util.find_git_ancestor,
				single_file_support = true,
				init_options = { format = { enable = true } },
				capabilities = capabilities,
			})
		elseif server == "pyright" then
			lspconfig.pyright.setup({
				capabilities = capabilities,
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
		elseif server == "arduino_language_server" then
			lspconfig.arduino_language_server.setup({
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
				root_dir = function(fname)
					local util = lspconfig.util
					return util.root_pattern(".git")(fname) or util.path.dirname(fname)
				end,
				single_file_support = true,
				capabilities = capabilities,
			})
		else
			-- 나머지 서버는 기본 옵션만
			lspconfig[server].setup({
				capabilities = capabilities,
			})
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
