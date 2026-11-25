local function open_preview()
    local api = vim.api
    local existing = {}

    for _, win in ipairs(api.nvim_tabpage_list_wins(0)) do
        existing[win] = true
    end

    vim.cmd("RenderMarkdown preview")

    for _, win in ipairs(api.nvim_tabpage_list_wins(0)) do
        if not existing[win] then
            vim.w[win].markdown_preview = true
            break
        end
    end
end

local function toggle_preview()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.w[win].markdown_preview then
            vim.api.nvim_win_close(win, false)
            return
        end
    end

    open_preview()
end

return {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {},

    keys = {
        {
            "<leader>mp",
            toggle_preview,
            ft = "markdown",
            desc = "Markdown 분할 미리보기 토글",
        },
    },
}
