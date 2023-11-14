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

-- main colorscheme
local colorscheme = {
    "rebelot/kanagawa.nvim",
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
        -- load the colorscheme here
        vim.cmd("colorscheme kanagawa-wave")
    end,
}

require("lazy").setup({
    -- colorscheme list
    "catppuccin/nvim",
    colorscheme,
    -- "iamcco/markdown-preview.nvim" is a Vim plugin for realtime markdown previewing
    "iamcco/markdown-preview.nvim",
    -- "tpope/vim-surround" is a Vim plugin that provides functionalities to easily delete, change and add surroundings in pairs.
    "tpope/vim-surround",
    -- "tpope/vim-sensible" is a Vim plugin that provides sensible default settings for Vim.
    "tpope/vim-sensible",
    -- "sindrets/diffview.nvim" is a Neovim plugin for easily reviewing and navigating diffs.
    "sindrets/diffview.nvim",
    -- "vim-scripts/DoxygenToolkit.vim": a Vim plugin for generating Doxygen documentation quickly and easily.
    require("plugins.doxygentoolkit_vim"),
    -- "kdheepak/lazygit.nvim" is a Vim plugin for integrating the lazygit terminal UI within the Neovim environment.
    require("plugins.lazygit_nvim"),
    -- 'akinsho/bufferline.nvim' is a Vim plugin that provides a tab-like buffer line with close icons and buffer sorting.
    require("plugins.bufferline_nvim"),
    -- "neoclide/coc.nvim" is a powerful, extensible Vim/Neovim plugin for autocompletion, linting, and language server protocol support.
    require("plugins.coc_nvim"),
    -- This plugin 'nvim-treesitter/nvim-treesitter' is used for syntax highlighting, indentation, and code navigation in Neovim using the Tree-sitter parser.
    require("plugins.nvim_treesitter"),
    -- This Vim plugin, 'numToStr/Comment.nvim', is used for adding, deleting, and navigating through comments in Neovim.
    require("plugins.comment_nvim"),
    -- A Neovim status line plugin written in Lua for better performance and customization.
    require("plugins.lualine_nvim"),
    -- This Vim plugin, "nvim-spectre", is a tool for Neovim that allows you to search and replace text across multiple files.
    require("plugins.nvim_spectre"),
    -- This Vim plugin, "madox2/vim-ai", is used to integrate AI features into the Vim text editor.
    require("plugins.vim_ai"),
    -- This Vim plugin ("norcalli/nvim-colorizer.lua") provides functionality for colorizing text in Neovim.
    require("plugins.nvim_colorizer_lua"),
    -- "folke/which-key.nvim" is a Vim plugin that provides a pop-up menu for keybindings to enhance workflow efficiency in Vim.
    require("plugins.which_key_nvim"),
    -- This Vim plugin "ethanholz/nvim-lastplace" helps to reopen files at the last edited position.
    require("plugins.nvim_lastplace"),
    -- This plugin 'nvim-telescope/telescope.nvim' is a highly extensible fuzzy finder over lists for Neovim.
    require("plugins.telescope_nvim"),
    -- This Vim plugin allows you to toggle the terminal window on and off.
    require("plugins.toggle_term"),
    -- This Vim plugin, Sniprun, allows for the execution of code snippets directly from the text editor.
    require("plugins.sniprun"),
})
