local comment_nvim = {
    'numToStr/Comment.nvim',
}

comment_nvim.config = function()
    require('Comment').setup {
        pre_hook = function()
            return vim.bo.commentstring
        end,
    }
end

return comment_nvim
