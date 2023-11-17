local navigator_lua = {
	"ray-x/navigator.lua",
	-- event = "BufRead",
	dependencies = {
		{ "ray-x/guihua.lua", build = "cd lua/fzy && make" },
		"neovim/nvim-lspconfig",
		"nvim-treesitter/nvim-treesitter",
		"nvim-treesitter/nvim-treesitter-refactor",
		"williamboman/mason.nvim",
		"hrsh7th/nvim-cmp",
		"folke/neodev.nvim",
	},
}

navigator_lua.config = function()
	local lspconfig = require("lspconfig")
	local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()

	local clang_configure = {
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
	}

	local lua_configure = {
		require("neodev").setup({}),
		settings = {
			Lua = {
				completion = {
					callSnippet = "Replace",
				},
			},
		},
	}

	require("navigator").setup({
		mason = true, -- mason user
		lsp = {
			servers = { "cmake" },

			code_lens_action = { enable = false },
			clangd = clang_configure,
			lua_ls = lua_configure,
			pyright = {},
			cmake = {},
			vimls = {},

			diagnostic = {
				virtual_text = true,
				severity_sort = true,
				update_in_insert = false,
				underline = false,
				float = {
					border = "rounded",
					source = "always",
				},
			},

			disable_lsp = {
				"angularls",
				"gopls",
				"tsserver",
				"flow",
				"bashls",
				"dockerls",
				"julials",
				"pylsp",
				"jedi_language_server",
				"jdtls",
				"html",
				"jsonls",
				"solargraph",
				"cssls",
				"yamlls",
				"ccls",
				"sqlls",
				"denols",
				"graphql",
				"dartls",
				"dotls",
				"kotlin_language_server",
				"nimls",
				"intelephense",
				"vuels",
				"phpactor",
				"omnisharp",
				"r_language_server",
				"rust_analyzer",
				"terraformls",
				"svelte",
				"texlab",
				"clojure_lsp",
				"elixirls",
				"sourcekit",
				"fsautocomplete",
				"vls",
				"hls",
			},
		},
	})
end

return navigator_lua
