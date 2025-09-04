-- ============================================================================
-- lua configure bradkim06
-- ============================================================================

-- useful lua link list
-- https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/
-- https://vonheikemen.github.io/devlog/tools/build-your-first-lua-config-for-neovim/

-- bootstrap lazy.nvim, LazyVim and your plugins
if vim.g.vscode then
	-- VSCode 환경일 경우
	require("plugin-vscode")
	require("config.vscode")
else
	-- 터미널 환경일 경우
	vim.g.mapleader = ","
	vim.g.maplocalleader = ","
	require("plugin")
	require("config.basic")
end
