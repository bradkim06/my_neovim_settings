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

require("lazy").setup("plugins")

-- require("lazy").setup({
-- 	-- ===============================================================================================
-- 	-- Colorscheme List
-- 	-- ===============================================================================================
-- 	"catppuccin/nvim",
-- 	colorscheme,
--
-- 	-- ===============================================================================================
-- 	-- Need Configuration Code plugin
-- 	-- ===============================================================================================
-- 	-- search and insert emojis using Telescope in Vim.
-- 	require("plugins.telescope_emoji"),
-- 	-- simple and nice looking neovim messages.
-- 	require("plugins.noice_nvim"),
-- 	-- display gui notifications.
-- 	require("plugins.nvim_notify"),
-- 	-- automatically format your code according to a specified style guide.
-- 	require("plugins.conform_nvim"),
-- 	-- showing changes in the sign column.
-- 	require("plugins.gitsigns_nvim"),
-- 	-- used to enhance the search functionality in Neovim.
-- 	require("plugins.wilder_nvim"),
-- 	-- generating Doxygen documentation quickly and easily.
-- 	require("plugins.doxygentoolkit_vim"),
-- 	-- integrating the lazygit terminal UI within the Neovim environment.
-- 	require("plugins.lazygit_nvim"),
-- 	-- tab-like buffer line with close icons and buffer sorting.
-- 	require("plugins.bufferline_nvim"),
-- 	-- syntax highlighting, indentation, and code navigation in Neovim using the Tree-sitter parser.
-- 	require("plugins.nvim_treesitter"),
-- 	-- adding, deleting, and navigating through comments in Neovim.
-- 	require("plugins.comment_nvim"),
-- 	-- A Neovim status line plugin written in Lua for better performance and customization.
-- 	require("plugins.lualine_nvim"),
-- 	-- allows you to search and replace text across multiple files.
-- 	require("plugins.nvim_spectre"),
-- 	-- integrate AI features into the Vim text editor.
-- 	require("plugins.vim_ai"),
-- 	-- functionality for colorizing text in Neovim.
-- 	require("plugins.nvim_colorizer_lua"),
-- 	-- reopen files at the last edited position.
-- 	require("plugins.nvim_lastplace"),
-- 	-- fuzzy finder over lists for Neovim.
-- 	require("plugins.telescope_nvim"),
-- 	-- toggle the terminal window on and off.
-- 	require("plugins.toggle_term"),
-- 	-- execution of code snippets directly from the text editor.
-- 	require("plugins.sniprun"),
-- 	-- provides a pop-up menu for keybindings to enhance workflow efficiency in Vim.
-- 	require("plugins.which_key_nvim"),
-- 	-- integrates the Mason templating system into the Neovim text editor.
-- 	require("plugins.mason_nvim"),
-- 	-- integrates Mason's Language Server Protocol configurations into Neovim.
-- 	require("plugins.mason_lspconfig_nvim"),
-- 	-- powerful, extensible Vim/Neofor autocompletion, linting, and language server protocol support.
-- 	require("plugins.coc_nvim"),
-- 	-- This Vim plugin is used to facilitate surround operations (like adding, changing, or deleting parentheses, brackets, quotes, etc.) in Neovim.
-- 	require("plugins.nvim_surround"),
--
-- 	-- ===============================================================================================
-- 	-- Only plugin install
-- 	-- ===============================================================================================
-- 	-- provides sensible default settings for Vim.
-- 	"tpope/vim-sensible",
-- 	-- Neofor easily reviewing and navigating diffs.
-- 	"sindrets/diffview.nvim",
--
-- 	-- ===============================================================================================
-- 	-- Unused Now
-- 	-- ===============================================================================================
-- 	-- -- configure and manage the Language Server Protocol (LSP) for Neovim.
-- 	-- require("plugins.nvim_lspconfig"),
-- 	-- A completion plugin for neovim coded in Lua.
-- 	-- require("plugins.nvim_cmp"),
-- })
