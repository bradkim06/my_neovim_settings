local conform_nvim = {
	"stevearc/conform.nvim",
	opts = {},
}

conform_nvim.config = function()
	require("conform").setup({
		-- Map of filetype to formatters
		formatters_by_ft = {
			c = { "clang_format" },
			cpp = { "clang_format" },
			dts = { "codespell" },
			cmake = { "cmake_format" },
			sh = { "shfmt" },
			lua = { "stylua" },
			-- Use a sub-list to run only the first available formatter
			javascript = { { "prettierd", "prettier" } },
			-- You can use a function here to determine the formatters dynamically
			python = function(bufnr)
				if require("conform").get_formatter_info("ruff_format", bufnr).available then
					return { "ruff_format" }
				else
					return { "isort", "black" }
				end
			end,
			markdown = { "mdformat" },
			json = { "prettierd" },
			jsonc = { "prettierd" },
			-- Use the "*" filetype to run formatters on all filetypes.
			["*"] = { "codespell" },
			-- Use the "_" filetype to run formatters on filetypes that don't
			-- have other formatters configured.
			["_"] = { "trim_whitespace" },
		},
		-- If this is set, Conform will run the formatter asynchronously after save.
		-- It will pass the table to conform.format().
		-- This can also be a function that returns the table.
		format_after_save = {
			lsp_fallback = true,
		},
		-- Set the log level. Use `:ConformInfo` to see the location of the log file.
		log_level = vim.log.levels.ERROR,
		-- Conform will notify you when a formatter errors
		notify_on_error = true,
	})
end

return conform_nvim
