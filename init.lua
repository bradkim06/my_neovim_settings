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
        end,
    })
    -- 3. WSL 클립보드
    --    win32yank.exe가 PATH에 있으면 사용 (빠르고 UTF-8/CRLF 자동 처리)
    --    없으면 clip.exe + PowerShell 사용. 한글이 깨지지 않도록
    --    복사는 UTF-16LE로 변환하고 붙여넣기는 UTF-8로 출력한다.
    if vim.fn.has("wsl") == 1 then
        if vim.fn.executable("win32yank.exe") == 1 then
            vim.g.clipboard = {
                name = "win32yank-wsl",
                copy = {
                    ["+"] = { "win32yank.exe", "-i", "--crlf" },
                    ["*"] = { "win32yank.exe", "-i", "--crlf" },
                },
                paste = {
                    ["+"] = { "win32yank.exe", "-o", "--lf" },
                    ["*"] = { "win32yank.exe", "-o", "--lf" },
                },
                cache_enabled = 0,
            }
        else
            local copy = { "sh", "-c", "iconv -f utf-8 -t utf-16le | clip.exe" }
            local paste = {
                "powershell.exe",
                "-NoProfile",
                "-NoLogo",
                "-Command",
                '[Console]::OutputEncoding=[System.Text.Encoding]::UTF8; [Console]::Out.Write((Get-Clipboard -Raw) -replace "`r", "")',
            }
            vim.g.clipboard = {
                name = "WslClipboard",
                copy = { ["+"] = copy, ["*"] = copy },
                paste = { ["+"] = paste, ["*"] = paste },
                cache_enabled = 0,
            }
        end
    end
end
