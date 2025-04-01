-----------------------------------------------------------
-- sniprun: 코드 스니펫을 빠르게 실행하는 플러그인
-----------------------------------------------------------
local M = {
	"michaelb/sniprun",
	branch = "master",
	-- 컴파일/설치 과정을 위한 명령어
	build = "sh install.sh",
	-- (참고) 'sh install.sh 1'로 local compile 가능 (Rust >= 1.65 필요)
	cmd = "SnipRun", -- Lazy.nvim에서 'SnipRun' 명령어가 실행될 때 로드
}

-----------------------------------------------------------
-- 플러그인 설정 함수 (Lazy.nvim이 로드 후 자동 호출)
-----------------------------------------------------------
function M.config()
	-- 기본적으로 sniprun은 require("sniprun").setup({ ... })로 설정을 초기화
	require("sniprun").setup({
		-----------------------------------------------------------
		-- 여기에 사용자 옵션을 넣을 수 있습니다.
		-- 예시:
		-- display = { "Classic", "VirtualTextOk" },
		-- interpreter_options = {
		--   GFM_original = { use_on_filetypes = {"markdown.pandoc"} },
		-- },
		-----------------------------------------------------------
	})
end

-----------------------------------------------------------
-- 추가 아이디어 / 개선사항
-----------------------------------------------------------
-- 1) Keymaps:
--    :SnipRun 명령어 대신, 아래처럼 키맵을 설정하여 특정 모션/범위만 빠르게 실행 가능.
--    vim.keymap.set("v", "<leader>r", ":SnipRun<CR>", { desc = "SnipRun in visual selection" })
--    vim.keymap.set("n", "<leader>r", ":SnipRun<CR>", { desc = "SnipRun current line" })
--
-- 2) Display options:
--    Sniprun은 결과를 다양한 형태(Classic, VirtualText, Terminal 등)로 표시 가능.
--    각 display 스타일을 조합할 수 있으니, 필요에 맞춰 설정해보세요.
--
-- 3) Interpreters:
--    Sniprun은 Python, Lua, C/C++, Rust, Shell 등 여러 언어 지원.
--    interpreter_options를 통해 특정 언어 해석 옵션 지정 가능.
--    예: interpreter_options = { GFM_original = { use_on_filetypes = {"markdown"} } }
--
-- 4) Performance:
--    대용량 파일에서 Sniprun을 사용할 경우, 해석기가 느려질 수 있으니,
--    필요에 따라 snippet size 제한 등을 고려할 수 있음.

return M
