local doxygentoolkit_vim = {
	"vim-scripts/DoxygenToolkit.vim",
	ft = { "c", "cc", "cpp", "hpp", "c++", "objc", "objcpp" },
}

doxygentoolkit_vim.config = function()
	vim.g.DoxygenToolkit_authorName = "bredkim06@gmail.com"
end

return doxygentoolkit_vim
