-- main colorscheme
local colorscheme = {
    -- 보조 테마: :colorscheme 실행 시에만 로드
    { "catppuccin/nvim", lazy = true },
    { "folke/tokyonight.nvim", lazy = true },
    {
        "rebelot/kanagawa.nvim",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            -- load the colorscheme here
            -- vim.o.background = ""
            vim.cmd.colorscheme("kanagawa-wave")
        end,
    },
}

return colorscheme
