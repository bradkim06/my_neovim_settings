-- ============================================================================
-- lua configure bradkim06
-- ============================================================================

-- useful lua link list
-- https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/
-- https://vonheikemen.github.io/devlog/tools/build-your-first-lua-config-for-neovim/

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.basic")
require("plugin")
