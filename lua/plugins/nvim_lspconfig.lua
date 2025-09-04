-- lua/plugins/lspconfig.lua

return {
	"neovim/nvim-lspconfig",
	event = "VeryLazy",
	dependencies = {
		"hrsh7th/nvim-cmp",
		"williamboman/mason.nvim", -- mason이 먼저 실행되도록 의존성 명시
	},
	config = function()
		-- 1번에서 분리한 공통 설정을 불러옵니다.
		local lsp_config = require("config.lsp")
		local on_attach = lsp_config.on_attach
		local capabilities = lsp_config.capabilities

		local lspconfig = require("lspconfig")
		vim.filetype.add({ extension = { ino = "arduino" } })

		-- 서버 목록을 다시 정의 (mason.lua와 동일하게 유지)
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

		-- 모든 서버에 공통으로 적용될 기본 설정을 정의
		local default_setup = function(server_name)
			lspconfig[server_name].setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})
		end

		-- 루프를 돌며 각 서버를 설정
		for _, server in ipairs(servers) do
			-- 특정 서버에 대한 커스텀 설정
			if server == "clangd" then
				lspconfig.clangd.setup({
					on_attach = on_attach,
					capabilities = capabilities,
					cmd = { "clangd", "--background-index", "--clang-tidy", "--completion-style=detailed" },
					filetypes = { "c", "cpp", "cxx", "cc" },
				})
			elseif server == "pyright" then
				lspconfig.pyright.setup({
					on_attach = on_attach,
					capabilities = capabilities,
					settings = { python = { analysis = { autoSearchPaths = true, useLibraryCodeForTypes = true } } },
				})
			elseif server == "arduino_language_server" then
				lspconfig.arduino_language_server.setup({
					on_attach = on_attach,
					capabilities = capabilities,
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
					root_dir = function(fname)
						return require("lspconfig.util").root_pattern(".git")(fname) or vim.fn.fnamemodify(fname, ":h")
					end,
				})
			else
				-- 커스텀 설정이 없는 나머지 서버는 기본 설정으로 setup
				default_setup(server)
			end
		end

		-- UI 관련 설정은 여기에 그대로 둡니다.
		vim.diagnostic.config({
			virtual_text = false,
			severity_sort = true,
			float = { border = "rounded", source = "always" },
		})
		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
		vim.lsp.handlers["textDocument/signatureHelp"] =
			vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
	end,
}
