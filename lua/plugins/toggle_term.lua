local toggle_term = {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = true,
}

toggle_term.keys = {
    { "<leader>t", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
}

toggle_term.init = function()
    function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        vim.keymap.set('t', '<leader>t', "<cmd>ToggleTerm<cr>", opts)
    end

    -- if you only want these mappings for toggle term use term://*toggleterm#* instead
    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
end

return toggle_term
