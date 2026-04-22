local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local utils = require("core.utils")
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
	{ import = "plugins.lsp" },
	{ import = "plugins" },
	{ import = "plugins.colorscheme" },
}, {
	checker = {
		enabled = true,
		notify = false,
	},
	change_detection = {
		notify = false,
	},
})

vim.cmd.colorscheme(utils.colorscheme.default)
