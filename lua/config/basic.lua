-- ============================================================================
-- Basic Settings
-- ============================================================================
vim.cmd('syntax on')
vim.cmd('filetype plugin on')

local set = vim.opt

set.wildmode = 'full'
set.hidden = true
set.incsearch = true

-- treat all numerals as decimal, regardless of whether they are padded with zeros.
set.nrformats = ""

-- set.background = "dark"
set.wildignorecase = true
set.hlsearch = true
set.encoding = "utf-8"
set.fileencodings = "utf8"

set.clipboard = "unnamed"
set.number = true
set.ignorecase = true
set.smartcase = true
set.tabstop = 4
set.shiftwidth = 4
set.softtabstop = 4
set.expandtab = true
set.mouse = "a"

-- 80 chars/line
set.textwidth = 80

if set.colorcolumn then
    set.colorcolumn = "80"
end

vim.g.python3_host_prog = '/opt/homebrew/bin/python3'

-- ============================================================================
-- Moving around, tabs, windows and buffers --
-- ============================================================================
-- MYVIMRC edit
vim.keymap.set('n', '<leader>ve', ':edit $MYVIMRC<cr>', { noremap = true })
vim.keymap.set('n', '<leader>vl', ':edit ~/.config/nvim/lua/basic.lua<cr>', { noremap = true })
vim.keymap.set('n', '<leader>vs', ':source $MYVIMRC<cr>', { noremap = true })

-- Close all buffer except the current
vim.cmd('command! BufOnly silent! execute "%bd|e#|bd#"')
vim.keymap.set('n', '<S-q>', ':BufOnly<CR>', { noremap = true })

-- Close current buffer
vim.keymap.set('n', '<Leader>q', ':bd<CR>', { noremap = true })

-- Move next buffer
vim.keymap.set('n', '<Tab>', ':bnext<CR>', { noremap = true })

-- Move previous buffer
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', { noremap = true })

-- ============================================================================
-- Useful Mappings
-- ============================================================================
-- Set keymap for '%%' command
vim.keymap.set('c', '%%', [[getcmdtype() == ':' ? expand('%:h').'/' : '%%']], { expr = true })

-- Remap Control+p to act as the Up arrow key in command-line mode
vim.keymap.set('c', '<C-p>', '<Up>', {})

-- Remap Control+n to act as the Down arrow key in command-line mode
vim.keymap.set('c', '<C-n>', '<Down>', {})

-- Search for the Current Selection (Redux)
vim.keymap.set('x', '*', [[:<C-u>lua _G.SetSearchPattern()<CR>/<C-R>=@/<CR><CR>]], {})
vim.keymap.set('x', '#', [[:<C-u>lua _G.SetSearchPattern()<CR>/<C-R>=@/<CR><CR>]], {})

-- This function sets the text selected in visual mode as the search pattern.
_G.SetSearchPattern = function()
    -- Save the current 's' register value in a temporary variable.
    local temp = vim.fn.getreg('s')

    -- Copy the selected area in visual mode to the 's' register.
    vim.cmd [[norm! gv"sy]]

    -- Set the search pattern, escaping special characters and newline characters.
    vim.fn.setreg('/', '\\V' .. vim.fn.substitute(vim.fn.escape(vim.fn.getreg('s'), '/\\'), '\\n', '\\\\n', 'g'))

    -- Restore the original 's' register value.
    vim.fn.setreg('s', temp)
end

-- ============================================================================
-- color
-- ============================================================================
-- Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
-- If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
-- (see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (os.getenv("TMUX") == nil and os.getenv('TERM_PROGRAM') ~= 'Apple_Terminal') then
    -- For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
    -- Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
    -- < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
    if (vim.fn.has("termguicolors")) then
        vim.o.termguicolors = true
    end
end


if vim.fn.has('nvim') then
    -- https://github.com/neovim/neovim/issues/2897#issuecomment-115464516
    vim.g.terminal_color_0 = '#4e4e4e'
    vim.g.terminal_color_1 = '#d68787'
    vim.g.terminal_color_2 = '#5f865f'
    vim.g.terminal_color_3 = '#d8af5f'
    vim.g.terminal_color_4 = '#85add4'
    vim.g.terminal_color_5 = '#d7afaf'
    vim.g.terminal_color_6 = '#87afaf'
    vim.g.terminal_color_7 = '#d0d0d0'
    vim.g.terminal_color_8 = '#626262'
    vim.g.terminal_color_9 = '#d75f87'
    vim.g.terminal_color_10 = '#87af87'
    vim.g.terminal_color_11 = '#ffd787'
    vim.g.terminal_color_12 = '#add4fb'
    vim.g.terminal_color_13 = '#ffafaf'
    vim.g.terminal_color_14 = '#87d7d7'
    vim.g.terminal_color_15 = '#e4e4e4'

    vim.o.fillchars = "vert:|,fold:-"

    -- Restore cursor position when opening file
    vim.api.nvim_exec([[
    autocmd BufReadPost *
                \ if line("'\"") >= 1 && line("'\"") <= line("$") |
                \   exe "normal! g`\"" |
                \ endif
    ]], false)
else
    vim.g.terminal_ansi_colors = {
        '#4e4e4e', '#d68787', '#5f865f', '#d8af5f',
        '#85add4', '#d7afaf', '#87afaf', '#d0d0d0',
        '#626262', '#d75f87', '#87af87', '#ffd787',
        '#add4fb', '#ffafaf', '#87d7d7', '#e4e4e4'
    }
end

-- ============================================================================
-- Helper mapping
-- ============================================================================
-- current year-month-date input
vim.keymap.set('i', '<F5>', '<C-R>=os.date("%Y-%m-%d")<cr>', {})
vim.keymap.set('i', '<F6>', '<C-R>=os.date("%Y-%m-%dT%H:%M:%S")<cr>', {})

-- Helper functions
-- Change Current Filename
function RenameFile()
    local old_name = vim.fn.expand('%')
    local new_name = vim.fn.input('New file name: ', vim.fn.expand('%'), 'file')
    if new_name ~= '' and new_name ~= old_name then
        vim.cmd('saveas ' .. new_name)
        vim.cmd('silent !rm ' .. old_name)
        vim.cmd('redraw')
    end
end

vim.keymap.set('n', '<leader>n', ':lua RenameFile()<cr>', {})

vim.keymap.set('n', '<F3>', ':!west build<cr>', {})
vim.keymap.set('n', '<F4>', ':!west flash<cr>', {})

-- Enable true color
vim.g['NVIM_TUI_ENABLE_TRUE_COLOR'] = 1

vim.cmd([[
  augroup vimrc_remember_cursor_position
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
  augroup END
]])
