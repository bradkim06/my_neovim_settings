-----------------------------------------------------------
-- render-markdown.nvim
--   - Markdown 파일을 열면 렌더링은 꺼진 상태 (원문 그대로 편집)
--   - <leader>mp : 오른쪽 분할 창에 렌더링된 미리보기 토글
--   - <leader>mr : 현재 버퍼에서 바로 렌더링 토글
-----------------------------------------------------------

-- 현재 버퍼의 렌더링 상태 (내부 state 모듈이 없으면 false로 간주)
local function buf_render_enabled(buf)
    local ok, state = pcall(require, "render-markdown.state")
    if not ok then
        return false
    end
    local ok_cfg, config = pcall(state.get, buf)
    return ok_cfg and config.enabled or false
end

local function open_preview()
    local api = vim.api
    local src_buf = api.nvim_get_current_buf()
    local was_enabled = buf_render_enabled(src_buf)
    local existing = {}

    for _, win in ipairs(api.nvim_tabpage_list_wins(0)) do
        existing[win] = true
    end

    vim.cmd("RenderMarkdown preview")

    for _, win in ipairs(api.nvim_tabpage_list_wins(0)) do
        if not existing[win] then
            vim.w[win].markdown_preview = true

            -- 미리보기를 닫으면 플러그인이 원본 버퍼 렌더링을 켜버리므로 원래 상태로 되돌림
            api.nvim_create_autocmd("BufWipeout", {
                buffer = api.nvim_win_get_buf(win),
                once = true,
                callback = function()
                    vim.schedule(function()
                        if not was_enabled and api.nvim_buf_is_valid(src_buf) then
                            api.nvim_buf_call(src_buf, function()
                                require("render-markdown").buf_disable()
                            end)
                        end
                    end)
                end,
            })
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
    opts = {
        enabled = false, -- 기본값: 렌더링 끔
        latex = { enabled = false }, -- latex 파서/변환기 미사용
        overrides = {
            -- 분할 미리보기 버퍼만 렌더링 (기본 render_modes 설정 유지)
            preview = { enabled = true, render_modes = true },
        },
    },

    keys = {
        {
            "<leader>mp",
            toggle_preview,
            ft = "markdown",
            desc = "Markdown 분할 미리보기 토글",
        },
        {
            "<leader>mr",
            "<cmd>RenderMarkdown buf_toggle<cr>",
            ft = "markdown",
            desc = "Markdown 버퍼 렌더링 토글",
        },
    },
}
