local nvim_treesitter = {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
        'JoosepAlviste/nvim-ts-context-commentstring',
    },
}

nvim_treesitter.config = function()
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
end

return nvim_treesitter
