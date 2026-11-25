-----------------------------------------------------------
-- telescope.nvim: 고급 검색/탐색 인터페이스
-- 리팩토링 + 주석 확장 예시
-----------------------------------------------------------
local M = {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy", -- Lazy.nvim에서 특정 이벤트가 발생할 때 로드
}

-----------------------------------------------------------
-- 플러그인 설정 함수 (Lazy.nvim에서 config 호출)
-----------------------------------------------------------
function M.config()
    -----------------------------------------------------------
    -- 1. 필요한 모듈 불러오기
    -----------------------------------------------------------
    local telescope = require("telescope")
    local action_layout = require("telescope.actions.layout")
    local actions = require("telescope.actions")
    local previewers = require("telescope.previewers")
    local Job = require("plenary.job")

    -----------------------------------------------------------
    -- 2. 바이너리 파일 미리보기 방지용 커스텀 maker
    -----------------------------------------------------------
    -- (charset이 binary인 파일만 "BINARY"로 표기,
    --  JSON 등 application/* 텍스트 파일과 빈 파일은 그대로 미리보기)
    -----------------------------------------------------------
    local function new_maker(filepath, bufnr, opts)
        filepath = vim.fn.expand(filepath)
        Job:new({
            command = "file",
            args = { "--mime", "-b", "-L", filepath }, -- 예: "application/json; charset=us-ascii"
            on_exit = function(j)
                local mime = j:result()[1] or ""
                local is_binary = mime:find("charset=binary", 1, true) and not mime:find("x-empty", 1, true)
                -- 비동기 콜백이므로 메인 루프에서 실행
                vim.schedule(function()
                    if not vim.api.nvim_buf_is_valid(bufnr) then
                        return -- 그 사이 다른 항목으로 이동한 경우
                    end
                    if not is_binary then
                        previewers.buffer_previewer_maker(filepath, bufnr, opts)
                    else
                        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
                    end
                end)
            end,
        }):start() -- :sync()는 미리보기마다 UI를 멈춤
    end

    -----------------------------------------------------------
    -- 3. Telescope 기본 설정 (telescope.setup)
    -----------------------------------------------------------
    telescope.setup({
        defaults = {
            -- (a) 바이너리 파일 처리
            buffer_previewer_maker = new_maker,

            -- (b) 레이아웃 설정: 세로(vertical) + 높이 99%
            layout_strategy = "vertical",
            layout_config = { height = 0.99 },

            -- (c) 기본 키 매핑: 프리뷰 토글, <esc>로 종료
            mappings = {
                n = {
                    ["<M-p>"] = action_layout.toggle_preview, -- alt + p
                },
                i = {
                    ["<M-p>"] = action_layout.toggle_preview,
                    ["<esc>"] = actions.close,
                },
            },
        },

        pickers = {
            -- (d) find_files 시 fd 사용, .git / .cache 제외
            find_files = {
                find_command = {
                    "fd",
                    "--hidden",
                    "--exclude",
                    ".cache",
                    "--exclude",
                    ".git",
                },
            },
        },

        -- (e) 확장(extensions) 사용 시 여기에 설정 가능
        -- extensions = {
        --   ...
        -- },
    })

    -----------------------------------------------------------
    -- 4. 사용자 정의 명령어: :Grep <word>
    -----------------------------------------------------------
    -- - 입력한 <word>를 telescope.builtin.grep_string()으로 검색
    -- - 50ms 뒤 해당 단어를 커서 위치에 삽입
    -- 예) :Grep foo => foo 검색 + 편집에 foo 삽입
    -----------------------------------------------------------
    vim.api.nvim_create_user_command("Grep", function(opts)
        require("telescope.builtin").grep_string({
            search = opts.fargs[1],
            file_ignore_patterns = { ".git/" },
        })
        vim.defer_fn(function()
            vim.api.nvim_put({ opts.fargs[1] .. " " }, "c", true, true)
        end, 50)
    end, { nargs = 1 })

    -----------------------------------------------------------
    -- 5. Keymap 설정 (nvim_set_keymap 대신 vim.keymap.set 사용)
    -----------------------------------------------------------
    local builtin = require("telescope.builtin")
    local function map_opts(desc)
        return { noremap = true, silent = true, desc = desc }
    end

    -- <leader><leader> : find_files
    vim.keymap.set("n", "<leader><leader>", builtin.find_files, map_opts("Telescope: find files"))

    -- <leader>g        : find_files (unrestricted) => fd --unrestricted
    vim.keymap.set(
        "n",
        "<leader>g",
        "<cmd>Telescope find_files find_command=fd,--unrestricted<cr>",
        map_opts("Telescope: find files (unrestricted)")
    )

    -- <leader>ag       : grep_string (현재 단어 검색)
    vim.keymap.set("n", "<leader>ag", builtin.grep_string, map_opts("Telescope: grep current word"))

    -- <leader>/        : live_grep (실시간 검색)
    vim.keymap.set("n", "<leader>/", builtin.live_grep, map_opts("Telescope: live grep"))

    -- <F1>             : Telescope 명령어 목록/메인 메뉴
    vim.keymap.set("n", "<F1>", "<cmd>Telescope<cr>", map_opts("Telescope: open command palette"))

    -- (B) [신규] lspsaga를 대체하는 LSP 관련 매핑
    -- Telescope를 사용하는 매핑
    vim.keymap.set("n", "gd", builtin.lsp_definitions, map_opts("LSP: Peek Definition"))
    vim.keymap.set("n", "grr", builtin.lsp_references, map_opts("LSP: Find References")) -- 0.11 기본 grr을 Telescope로 대체
    -- vim.keymap.set({ "n", "v" }, "<leader>ca", builtin.lsp_code_actions, map_opts("LSP: Code Action"))
    vim.keymap.set("n", "gG", builtin.diagnostics, map_opts("LSP: Workspace Diagnostics"))

    -- Neovim 네이티브 LSP 기능을 사용하는 매핑
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, map_opts("LSP: Rename Symbol"))
    -- K(hover), [d / ]d(진단 이동)는 Neovim 0.11 기본 매핑을 사용
end

return M
