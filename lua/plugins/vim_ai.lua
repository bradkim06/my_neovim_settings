local vim_ai  = {
    "madox2/vim-ai",
}

vim_ai.config = function()
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
    vim.keymap.set('x', '<leader>c',
        ':AI Please write a commit message like a Linux kernel developer would.<CR>', { noremap = true })
end

return vim_ai
