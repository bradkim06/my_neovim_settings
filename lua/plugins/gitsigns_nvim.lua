-----------------------------------------------------------
-- gitsigns.nvim 플러그인 설정 (lazy.nvim 관리)
-----------------------------------------------------------
local gitsigns_nvim = {
	"lewis6991/gitsigns.nvim", -- Git 변경사항을 표시하는 플러그인
}

-----------------------------------------------------------
-- 플러그인 설정 함수
-----------------------------------------------------------
gitsigns_nvim.config = function()
	require("gitsigns").setup({
		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")

			local function map(mode, l, r, opts)
				opts = opts or {}
				opts.buffer = bufnr
				vim.keymap.set(mode, l, r, opts)
			end

			-- Navigation
			map("n", "]h", function()
				if vim.wo.diff then
					vim.cmd.normal({ "]c", bang = true })
				else
					gitsigns.nav_hunk("next")
				end
			end)

			map("n", "[h", function()
				if vim.wo.diff then
					vim.cmd.normal({ "[c", bang = true })
				else
					gitsigns.nav_hunk("prev")
				end
			end)

			map("n", "<leader>h", gitsigns.preview_hunk, { desc = "Preview Git Hunk" }) -- 설명 추가
		end,
	})
end

-----------------------------------------------------------
-- 플러그인 반환
-----------------------------------------------------------
return gitsigns_nvim
