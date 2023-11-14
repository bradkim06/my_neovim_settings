local wilder_nvim = {
    'gelguy/wilder.nvim',
    lazy = false,
    dependencies = { "romgrk/fzy-lua-native", "nixprime/cpsm", "sharkdp/fd", "junegunn/fzf.vim", "junegunn/fzf" },
}

wilder_nvim.config = function()
    -- config goes here
    local wilder = require('wilder')
    wilder.setup({ modes = { ':', '/', '?' } })

    wilder.set_option('pipeline', {
        wilder.branch(
            wilder.python_file_finder_pipeline({
                -- to use ripgrep : {'rg', '--files'}
                -- to use fd      : {'fd', '-tf'}
                file_command = { 'fd', '-tf' },
                -- to use fd      : {'fd', '-td'}
                dir_command = { 'fd', '-td' },
                -- use {'cpsm_filter'} for performance, requires cpsm vim plugin
                -- found at https://github.com/nixprime/cpsm
                filters = { 'fuzzy_filter', 'difflib_sorter' },
            }),
            wilder.cmdline_pipeline({
                -- sets the language to use, 'vim' and 'python' are supported
                language = 'python',
                -- 0 turns off fuzzy matching
                -- 1 turns on fuzzy matching
                -- 2 partial fuzzy matching (match does not have to begin with the same first letter)
                fuzzy = 1,
            }),
            wilder.python_search_pipeline({
                -- can be set to wilder#python_fuzzy_delimiter_pattern() for stricter fuzzy matching
                pattern = wilder.python_fuzzy_pattern(),
                -- omit to get results in the order they appear in the buffer
                sorter = wilder.python_difflib_sorter(),
                -- can be set to 're2' for performance, requires pyre2 to be installed
                -- see :h wilder#python_search() for more details
                engine = 're',
            })
        ),
    })

    local highlighters = {
        wilder.pcre2_highlighter(),
        wilder.lua_fzy_highlighter(),
    }

    local popupmenu_renderer = wilder.popupmenu_renderer(
        wilder.popupmenu_border_theme({
            -- 'single', 'double', 'rounded' or 'solid'
            -- can also be a list of 8 characters, see :h wilder#popupmenu_palette_theme() for more details
            border = 'rounded',
            max_height = '90%',         -- max height of the palette
            min_height = 0,             -- set to the same as 'max_height' for a fixed height window
            prompt_position = 'bottom', -- 'top' or 'bottom' to set the location of the prompt
            reverse = 0,                -- set to 1 to reverse the order of the list, use in combination with 'prompt_position'
            highlighter = highlighters,
            highlights = {
                accent = wilder.make_hl('WilderAccent', 'Pmenu', { { a = 1 }, { a = 1 }, { foreground = '#f4468f' } }),
            },

            left = {
                ' ',
                wilder.popupmenu_devicons(),
            },
            right = {
                ' ',
                wilder.popupmenu_scrollbar(),
            },
        })
    )

    local wildmenu_renderer = wilder.wildmenu_renderer({
        highlighter = highlighters,
        separator = ' · ',
        left = { ' ', wilder.wildmenu_spinner(), ' ' },
        right = { ' ', wilder.wildmenu_index() },
    })

    wilder.set_option('renderer', wilder.renderer_mux({
        [':'] = popupmenu_renderer,
        ['/'] = popupmenu_renderer,
        substitute = wildmenu_renderer,
    }))
end

return wilder_nvim
