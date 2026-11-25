-- ============================================================================
-- lua configure bradkim06
-- ============================================================================

-- useful lua link list
-- https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/
-- https://vonheikemen.github.io/devlog/tools/build-your-first-lua-config-for-neovim/

-- bootstrap lazy.nvim, LazyVim and your plugins
if vim.g.vscode then
    -- VSCode 환경일 경우
    require("plugin-vscode")
    require("config.vscode")
else
    -- 터미널 환경일 경우
    vim.g.mapleader = ","
    vim.g.maplocalleader = ","
    require("plugin")
    require("config.basic")
    -- 1. 파일 줄바꿈 포맷: Unix 우선, DOS 자동 인식
    vim.opt.fileformats = { "unix", "dos" }

    -- 2. 저장 시 화면에 남아있는 ^M(\r) 자동 제거 (커서 위치 유지)
    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function()
            local view = vim.fn.winsaveview()
            vim.cmd([[silent! %s/\r//g]])
            vim.fn.winrestview(view)
        end
    })
    if vim.fn.has("wsl") == 1 then
        vim.g.clipboard = {
            name = "WslClipboard",
            copy = {
                ["+"] = "clip.exe",
                ["*"] = "clip.exe",
            },
            paste = {
                ["+"] =
                'powershell.exe -NoProfile -Command [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
                ["*"] =
                'powershell.exe -NoProfile -Command [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            },
            cache_enabled = 0,
        }
    end
end
