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
				filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
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
		virtual_text = true,
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

	-- -- Global mappings.
	-- -- See `:help vim.diagnostic.*` for documentation on any of the below functions
	-- vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
	-- vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
	-- vim.keymap.set("n", "]d", vim.diagnostic.goto_next)

	-- Use LspAttach autocommand to only map the following keys
	-- after the language server attaches to the current buffer
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("UserLspConfig", {}),
		callback = function(ev)
			-- Enable completion triggered by <c-x><c-o>
			vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

			-- Buffer local mappings.
			-- See `:help vim.lsp.*` for documentation on any of the below functions
			local opts = { buffer = ev.buf }
			-- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
			-- vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
			-- vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
			vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
			-- vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
			-- vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
			-- vim.keymap.set("n", "<space>wl", function()
			-- 	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			-- end, opts)
			-- vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
			-- vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
			-- vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
			-- vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		end,
	})
end

return nvim_lspconfig
