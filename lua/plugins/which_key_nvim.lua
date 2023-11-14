local which_key_nvim = {
    "folke/which-key.nvim",
    event = "VeryLazy",
}

which_key_nvim.config = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300

    vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
            -- appearance
            -- vim.api.nvim_set_hl(0, 'WhichKey', { fg = '#FF8080' })
            -- vim.api.nvim_set_hl(0, 'WhichKeyGroup', { fg = '#C70039' })
            -- vim.api.nvim_set_hl(0, 'WhichKeySeparator', { fg = '#FFCF96' })
            -- vim.api.nvim_set_hl(0, 'WhichKeyDesc', { fg = '#00ADB5' })
            -- vim.api.nvim_set_hl(0, 'WhichKeyFloat', { bg = '#222831' })
            -- vim.api.nvim_set_hl(0, 'WhichKeyBorder', { bg = '#222831' })
            vim.api.nvim_set_hl(0, 'WhichKeyValue', { fg = '#EEEEEE' })
        end,
    })
end

which_key_nvim.opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
}

return which_key_nvim
