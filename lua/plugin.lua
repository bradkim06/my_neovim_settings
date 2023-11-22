local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- require("lazy").setup("plugins")

require("lazy").setup({
	-- ===============================================================================================
	-- Experimental Plugin
	-- ===============================================================================================
	{
		"chrisgrieser/nvim-early-retirement",
		config = true,
		event = "VeryLazy",
	},
	{
		"ahmedkhalf/project.nvim",
		dependencies = "nvim-telescope/telescope.nvim",
		config = function()
			require("project_nvim").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
			require("telescope").load_extension("projects")
		end,
	},
	{
		"hinell/lsp-timeout.nvim",
		dependencies = { "neovim/nvim-lspconfig" },
	},
	{
		"jackMort/ChatGPT.nvim",
		event = "VeryLazy",
		config = function()
			require("chatgpt").setup({
				api_key_cmd = "op read op://private/OpenAI/credential --no-newline",
				actions_paths = { "~/.config/nvim/lua/plugins/chatgpt_nvim/actions.json" },
			})
		end,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
	},
	-- ===============================================================================================
	-- Colorscheme List
	-- ===============================================================================================
	"catppuccin/nvim",
	require("plugins.colorscheme"),
	-- ===============================================================================================
	-- Need Configuration Code plugin
	-- ===============================================================================================
	-- search and insert emojis using Telescope in Vim.
	require("plugins.telescope_emoji"),
	-- simple and nice looking neovim messages.
	require("plugins.noice_nvim"),
	-- automatically format your code according to a specified style guide.
	require("plugins.conform_nvim"),
	-- showing changes in the sign column.
	require("plugins.gitsigns_nvim"),
	-- integrating the lazygit terminal UI within the Neovim environment.
	require("plugins.lazygit_nvim"),
	-- tab-like buffer line with close icons and buffer sorting.
	require("plugins.bufferline_nvim"),
	-- syntax highlighting, indentation, and code navigation in Neovim using the Tree-sitter parser.
	require("plugins.nvim_treesitter"),
	-- adding, deleting, and navigating through comments in Neovim.
	require("plugins.comment_nvim"),
	-- A Neovim status line plugin written in Lua for better performance and customization.
	require("plugins.lualine_nvim"),
	-- allows you to search and replace text across multiple files.
	require("plugins.nvim_spectre"),
	-- functionality for colorizing text in Neovim.
	require("plugins.nvim_colorizer_lua"),
	-- reopen files at the last edited position.
	require("plugins.nvim_lastplace"),
	-- fuzzy finder over lists for Neovim.
	require("plugins.telescope_nvim"),
	-- execution of code snippets directly from the text editor.
	require("plugins.sniprun"),
	-- provides a pop-up menu for keybindings to enhance workflow efficiency in Vim.
	require("plugins.which_key_nvim"),
	-- This Vim plugin is used to facilitate surround operations (like adding, changing, or deleting parentheses, brackets, quotes, etc.) in Neovim.
	require("plugins.nvim_surround"),
	-- A completion plugin for neovim coded in Lua.
	require("plugins.nvim_cmp"),
	-- automatically pairs brackets, quotes, and other characters in Neovim.
	require("plugins.nvim_autopairs"),
	-- generating documentation comments in your code.
	require("plugins.neogen"),
	-- for linting code within Neovim.
	require("plugins.nvim_lint"),
	-- configure and manage the Language Server Protocol (LSP) for Neovim.
	require("plugins.nvim_lspconfig"),
	-- enhances the LSP (Language Server Protocol) experience with helpful features and visual aids.
	require("plugins.lspsaga_nvim"),
	-- ===============================================================================================
	-- Only plugin install
	-- ===============================================================================================
	-- provides sensible default settings for Vim.
	"tpope/vim-sensible",
	-- Neofor easily reviewing and navigating diffs.
	"sindrets/diffview.nvim",

	-- ===============================================================================================
	-- Unused Now
	-- ===============================================================================================
	-- -- provides enhanced navigation features for Neovim 0.5+.
	-- require("plugins.navigator_lua"),

	-- -- used to enhance the search functionality in Neovim.
	-- require("plugins.wilder_nvim"),
})
