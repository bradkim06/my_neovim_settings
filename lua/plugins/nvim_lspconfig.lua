local nvim_lspconfig = {
	"neovim/nvim-lspconfig",
	dependencies = {
		"folke/neodev.nvim",
		"hrsh7th/nvim-cmp",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
}

local server_list = {
	"neocmake",
	"clangd",
	"jsonls",
	"lua_ls",
	"marksman",
	"pyright",
	"vimls",
}

nvim_lspconfig.config = function()
	-- Add additional capabilities supported by nvim-cmp
	local lspconfig = require("lspconfig")
	local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()

	require("mason").setup()
	require("mason-lspconfig").setup({
		ensure_installed = server_list,
	})

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
		elseif lsp == "lua_ls" then
			require("neodev").setup({})
			lspconfig[lsp].setup({
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
					},
				},
				capabilities = cmp_capabilities,
			})
		elseif lsp == "neocmake" then
			lspconfig[lsp].setup({
				cmd = { "neocmakelsp", "--stdio" },
				filetypes = { "cmake" },
				root_dir = function(fname)
					return require("lspconfig").util.find_git_ancestor(fname)
				end,
				single_file_support = true, -- suggested
				init_options = {
					format = {
						enable = true,
					},
				},
				capabilities = cmp_capabilities,
			})
		else
			lspconfig[lsp].setup({
				capabilities = cmp_capabilities,
			})
		end
	end

	vim.diagnostic.config({
		virtual_text = false,
		severity_sort = true,
		underline = false,
		float = {
			border = "rounded",
			source = "always",
		},
	})

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

	vim.lsp.handlers["textDocument/signatureHelp"] =
		vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("UserLspConfig", {}),
		callback = function(ev)
			-- Buffer local mappings.
			local opts = function(desc)
				return { noremap = true, silent = true, desc = desc }
			end
			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("hover"))
			vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts("signature_help"))
		end,
	})
end

return nvim_lspconfig
