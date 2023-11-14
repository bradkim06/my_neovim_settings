local bufferline_nvim = {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
}

bufferline_nvim.config = function()
    require("bufferline").setup {}
end

return bufferline_nvim
