local nvim_colorizer_lua = {
    "norcalli/nvim-colorizer.lua",
}

nvim_colorizer_lua.config = function()
    require 'colorizer'.setup()
end

return nvim_colorizer_lua
