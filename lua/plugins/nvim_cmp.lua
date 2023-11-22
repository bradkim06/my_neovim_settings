local nvim_cmp = {
	"hrsh7th/nvim-cmp",
	event = { "InsertEnter" },

	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",

		--  For luasnip users.
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",

		-- Better Beauty
		"onsails/lspkind.nvim",
		"windwp/nvim-autopairs",
	},
}

-- configure example https://vonheikemen.github.io/devlog/tools/setup-nvim-lspconfig-plus-nvim-cmp/
nvim_cmp.config = function()
	-- If you want insert `(` after select function or method item
	vim.opt.completeopt = { "menu", "menuone", "noselect" }
	local cmp = require("cmp")

	local has_words_before = function()
		unpack = unpack or table.unpack
		local line, col = unpack(vim.api.nvim_win_get_cursor(0))
		return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
	end

	local luasnip = require("luasnip")

	cmp.setup({
		snippet = {
			-- REQUIRED - you must specify a snippet engine
			expand = function(args)
				luasnip.lsp_expand(args.body) -- For `luasnip` users.
			end,
		},
		window = {
			completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
		},

		sources = {
			{ name = "path" },
			{ name = "nvim_lsp", keyword_length = 1 },
			{ name = "buffer", keyword_length = 3 },
			{ name = "luasnip", keyword_length = 2 },
		},

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

		mapping = cmp.mapping.preset.insert({
			["<C-u>"] = cmp.mapping.scroll_docs(-4),
			["<C-d>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-c>"] = cmp.mapping.abort(),

			["<CR>"] = cmp.mapping({
				i = function(fallback)
					if cmp.visible() and cmp.get_active_entry() then
						cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
					else
						fallback()
					end
				end,
				s = cmp.mapping.confirm({ select = true }),
				c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
			}),

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

			["<Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
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

	-- local cmp_autopairs = require("nvim-autopairs.completion.cmp")
	-- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

return nvim_cmp
