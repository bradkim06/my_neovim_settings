local nvim_notify = {
	"rcarriga/nvim-notify",
}

-- This function configures notifications for the Neovim editor, specifically for the Conquer of Completion (coc.nvim) plugin which provides Language Server Protocol (LSP) support, including status updates and diagnostic messages.
nvim_notify.config = function()
	vim.notify = require("notify")

	local coc_status_record = {}

	function Coc_status_notify(msg, level)
		local notify_opts =
			{ title = "LSP Status", timeout = 500, hide_from_history = true, on_close = Reset_coc_status_record }
		-- if coc_status_record is not {} then add it to notify_opts to key called "replace"
		if coc_status_record ~= {} then
			notify_opts["replace"] = coc_status_record.id
		end
		coc_status_record = vim.notify(msg, level, notify_opts)
	end

	function Reset_coc_status_record()
		coc_status_record = {}
	end

	local coc_diag_record = {}

	function Coc_diag_notify(msg, level)
		local notify_opts = { title = "LSP Diagnostics", timeout = 500, on_close = Reset_coc_diag_record }
		-- if coc_diag_record is not {} then add it to notify_opts to key called "replace"
		if coc_diag_record ~= {} then
			notify_opts["replace"] = coc_diag_record.id
		end
		coc_diag_record = vim.notify(msg, level, notify_opts)
	end

	function Reset_coc_diag_record()
		coc_diag_record = {}
	end

	function DiagnosticNotify()
		local info = vim.b.coc_diagnostic_info or {}
		if vim.tbl_isempty(info) then
			return ""
		end
		local msgs = {}
		local level = "info"
		if info.warning then
			level = "warn"
		end
		if info.error then
			level = "error"
		end
		if info.error then
			table.insert(msgs, " Errors: " .. info.error)
		end
		if info.warning then
			table.insert(msgs, " Warnings: " .. info.warning)
		end
		if info.information then
			table.insert(msgs, " Infos: " .. info.information)
		end
		if info.hint then
			table.insert(msgs, " Hints: " .. info.hint)
		end
		local msg = table.concat(msgs, "\n")
		if msg == "" then
			msg = " All OK"
		end
		vim.coc_diag_notify(msg, level)
	end

	function StatusNotify()
		local status = vim.g.coc_status or ""
		local level = "info"
		if status == "" then
			return ""
		end
		vim.coc_status_notify(status, level)
	end

	function InitCoc()
		vim.notify("Initialized coc.nvim for LSP support", vim.log.levels.INFO, { title = "LSP Status" })
	end

	-- notifications
	vim.cmd([[autocmd User CocNvimInit lua InitCoc()]])
	vim.cmd([[autocmd User CocDiagnosticChange lua DiagnosticNotify()]])
	vim.cmd([[autocmd User CocStatusChange lua StatusNotify()]])
end

return nvim_notify
