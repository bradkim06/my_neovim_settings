local keyset = vim.keymap.set

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

local doxygen        = {
    "vim-scripts/DoxygenToolkit.vim",
    config = function()
        vim.g.DoxygenToolkit_authorName = "bredkim06@gmail.com"
    end,
}

local gruvbox        = {
    "morhetz/gruvbox",
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    init = function()
        -- load the colorscheme here
        --
        vim.api.nvim_create_autocmd("ColorScheme", {
            pattern = "*",
            callback = function()
                -- appearance
                vim.api.nvim_set_hl(0, 'WhichKey', { fg = '#FF8080' })
                vim.api.nvim_set_hl(0, 'WhichKeyGroup', { fg = '#C70039' })
                vim.api.nvim_set_hl(0, 'WhichKeySeparator', { fg = '#FFCF96' })
                vim.api.nvim_set_hl(0, 'WhichKeyDesc', { fg = '#00ADB5' })
                vim.api.nvim_set_hl(0, 'WhichKeyFloat', { bg = '#222831' })
                vim.api.nvim_set_hl(0, 'WhichKeyBorder', { bg = '#222831' })
                vim.api.nvim_set_hl(0, 'WhichKeyValue', { fg = '#EEEEEE' })
            end,
        })


        vim.cmd([[colorscheme gruvbox]])
    end,
}

local lazygit        = {
    "kdheepak/lazygit.nvim",
    keys = {
        { "<F2>", "<cmd>LazyGit<cr>" },
    }
}

local which_key      = {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
    end,
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
    }
}

local bufferline     = {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
        require("bufferline").setup {}
    end
}

local treesitter     = {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
        require('nvim-treesitter.configs').setup {
            ensure_installed = 'all',
            sync_install = false,
            auto_install = true,
            highlight = {
                enable = true,
            },
            context_commentstring = {
                enable = true,
            },
        }
    end,
    dependencies = {
        'JoosepAlviste/nvim-ts-context-commentstring',
    },
}

local comment        = {
    'numToStr/Comment.nvim',
    config = function()
        require('Comment').setup {
            pre_hook = function()
                return vim.bo.commentstring
            end,
        }
    end,
}

local lualine        = {
    "nvim-lualine/lualine.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
        options = {
            icons_enabled = true,
            theme = 'gruvbox',
            component_separators = { left = '', right = '' },
            section_separators = { left = '', right = '' },
            disabled_filetypes = {
                statusline = {},
                winbar = {},
            },
            ignore_focus = {},
            always_divide_middle = true,
            globalstatus = false,
            refresh = {
                statusline = 1000,
                tabline = 1000,
                winbar = 1000,
            }
        },
        sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'branch', 'diff', 'diagnostics' },
            lualine_c = { 'filename' },
            lualine_x = { 'encoding', 'fileformat', 'filetype' },
            lualine_y = { 'progress' },
            lualine_z = { 'location' }
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { 'filename' },
            lualine_x = { 'location' },
            lualine_y = {},
            lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
    }
}

local fzf_vim        = {
    "junegunn/fzf.vim",
    init = function()
        -- Initialize configuration dictionary
        vim.g.fzf_vim = {}
        -- Set fzf default command
        vim.g.FZF_DEFAULT_COMMAND = "rg --files --hidden --glob '!.git/**' --glob '!.idea'"

        -- Set fzf colors
        vim.g.fzf_colors = {
            fg = { "fg", "Normal" },
            bg = { "bg", "Normal" },
            hl = { "fg", "Comment" },
            ["fg+"] = { "fg", "CursorLine", "CursorColumn", "Normal" },
            ["bg+"] = { "bg", "CursorLine", "CursorColumn" },
            ["hl+"] = { "fg", "Statement" },
            info = { "fg", "PreProc" },
            border = { "fg", "Ignore" },
            prompt = { "fg", "Conditional" },
            pointer = { "fg", "Exception" },
            marker = { "fg", "Keyword" },
            spinner = { "fg", "Label" },
            header = { "fg", "Comment" }
        }

        -- Set fzf action to use build_quickfix_list function
        vim.g.fzf_action = { ["ctrl-v"] = "vsplit" }

        -- Set preview window settings
        vim.g.fzf_preview_window = { "right,50%", "ctrl-t" }
        vim.g.fzf_layout = { window = { width = 0.9, height = 0.9 } }

        -- Map keys to fzf commands
        local opts = { silent = true, noremap = true }
        keyset("n", "<Leader><Leader>", "<cmd>Files<cr>", opts)
        keyset("n", "<Leader>ag", ":Rg <C-R><C-W><CR>", opts)
        keyset("n", "<Leader>/", "<cmd>Rg<CR>", opts)
        keyset("n", "<F1>", "<cmd>Maps<cr>", opts)
    end
}

local spectre        = {
    "nvim-pack/nvim-spectre",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
        require('spectre').setup({
            mapping = {
                ['send_to_qf'] = {
                    map = "<C-q>",
                    cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
                    desc = "send all items to quickfix"
                },
            }
        })
        keyset('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
            desc = "Toggle Spectre"
        })
        keyset('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
            desc = "Search current word"
        })
        keyset('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
            desc = "Search current word"
        })
        keyset('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
            {
                desc = "Search on current file"
            })
    end,
}

local vim_ai         = {
    "madox2/vim-ai",
    config = function()
        vim.g.vim_ai_complete = {
            engine = "chat",
            options = {
                model = "gpt-4",
                endpoint_url = "https://api.openai.com/v1/chat/completions",
                max_tokens = 4000,
                temperature = 0.2,
                request_timeout = 20,
            },
            ui = {
                paste_mode = 1,
            },
        }

        vim.g.vim_ai_edit = {
            engine = "chat",
            options = {
                model = "gpt-4",
                endpoint_url = "https://api.openai.com/v1/chat/completions",
                max_tokens = 4000,
                temperature = 0.2,
                request_timeout = 20,
            },
        }
        keyset('x', '<leader>c',
            ':AI Please write a commit message like a Linux kernel developer would.<CR>', { noremap = true })
    end
}

local nvim_colorizer = {
    "norcalli/nvim-colorizer.lua",
    config = function()
        require 'colorizer'.setup()
    end
}

require("lazy").setup({
    -- "neoclide/coc.nvim" is a powerful, extensible Vim/Neovim plugin for autocompletion, linting, and language server protocol support.
    "neoclide/coc.nvim",
    -- "tpope/vim-sensible" is a Vim plugin that provides sensible default settings for Vim.
    "tpope/vim-sensible",
    -- "sindrets/diffview.nvim" is a Neovim plugin for easily reviewing and navigating diffs.
    "sindrets/diffview.nvim",
    -- "vim-scripts/DoxygenToolkit.vim": a Vim plugin for generating Doxygen documentation quickly and easily.
    doxygen,
    -- "kdheepak/lazygit.nvim" is a Vim plugin for integrating the lazygit terminal UI within the Neovim environment.
    lazygit,
    -- "iamcco/markdown-preview.nvim" is a Vim plugin for realtime markdown previewing
    "iamcco/markdown-preview.nvim",
    -- "zhimsel/vim-stay" is a Vim plugin that preserves the cursor position and opened folds when you reopen a file.
    "zhimsel/vim-stay",
    -- "tpope/vim-surround" is a Vim plugin that provides functionalities to easily delete, change and add surroundings in pairs.
    "tpope/vim-surround",
    -- 'akinsho/bufferline.nvim' is a Vim plugin that provides a tab-like buffer line with close icons and buffer sorting.
    bufferline,
    -- This plugin 'nvim-treesitter/nvim-treesitter' is used for syntax highlighting, indentation, and code navigation in Neovim using the Tree-sitter parser.
    treesitter,
    -- This Vim plugin, 'numToStr/Comment.nvim', is used for adding, deleting, and navigating through comments in Neovim.
    comment,
    -- A Neovim status line plugin written in Lua for better performance and customization.
    lualine,
    -- This Vim plugin integrates the fuzzy finder 'fzf' into Vim for fast file navigation and searching.
    "junegunn/fzf",
    fzf_vim,
    -- This Vim plugin, "nvim-spectre", is a tool for Neovim that allows you to search and replace text across multiple files.
    spectre,
    -- This Vim plugin, "madox2/vim-ai", is used to integrate AI features into the Vim text editor.
    vim_ai,
    -- This Vim plugin ("norcalli/nvim-colorizer.lua") provides functionality for colorizing text in Neovim.
    nvim_colorizer,
    -- "folke/which-key.nvim" is a Vim plugin that provides a pop-up menu for keybindings to enhance workflow efficiency in Vim.
    which_key,
    -- "morhetz/gruvbox" is a retro groove color scheme for Vim.
    gruvbox,
})

-- ============================================================================
-- coc.nvim
-- ============================================================================
-- Some servers have issues with backup files, see #649
vim.opt.backup = false
vim.opt.writebackup = false

-- Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
-- delays and poor user experience
vim.opt.updatetime = 300

-- Always show the signcolumn, otherwise it would shift the text each time
-- diagnostics appeared/became resolved
vim.opt.signcolumn = "yes"

-- Autocomplete
function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Use Tab for trigger completion with characters ahead and navigate
-- NOTE: There's always a completion item selected by default, you may want to enable
-- no select by setting `"suggest.noselect": true` in your configuration file
-- NOTE: Use command ':verbose imap <tab>' to make sure Tab is not mapped by
-- other plugins before putting this into your config
local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

-- Make <CR> to accept selected completion item or notify coc.nvim to format
-- <C-g>u breaks current undo, please make your own choice
keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

-- Use <c-space> to trigger completion
keyset("i", "<c-space>", "coc#refresh()", { silent = true, expr = true })

-- Use `[g` and `]g` to navigate diagnostics
-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true })
keyset("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true })

-- GoTo code navigation
keyset("n", "gd", "<Plug>(coc-definition)", { silent = true })
keyset("n", "gr", "<Plug>(coc-references)", { silent = true })

-- Use K to show documentation in preview window
function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({ 'vim', 'help' }, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end

keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', { silent = true })

-- Symbol renaming
keyset("n", "<leader>rn", "<Plug>(coc-rename)", { silent = true })

-- Apply the most preferred quickfix action on the current line.
keyset("n", "<leader>f", "<Plug>(coc-fix-current)", opts)

-- Remap keys for apply refactor code actions.
keyset("n", "<leader>re", "<Plug>(coc-codeaction-refactor)", { silent = true })
keyset("x", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })
keyset("n", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })

-- Run the Code Lens actions on the current line
keyset("n", "<leader>cl", "<Plug>(coc-codelens-action)", opts)

-- Use CTRL-S for selections ranges
-- Requires 'textDocument/selectionRange' support of language server
keyset("n", "<C-s>", "<Plug>(coc-range-select)", { silent = true })
keyset("x", "<C-s>", "<Plug>(coc-range-select)", { silent = true })

-- Add `:Format` command to format current buffer
vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

-- " Add `:Fold` command to fold current buffer
vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", { nargs = '?' })
