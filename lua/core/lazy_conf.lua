local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
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
	{ "LazyVim/LazyVim", import = "lazyvim.plugins" },
	{ import = "lazyvim.plugins.extras.formatting.prettier" },
	{ import = "lazyvim.plugins.extras.lang.tailwind" },
	{ import = "plugins" },
	{ import = "plugins.lsp" },
	{ "folke/flash.nvim", enabled = false },
}, {
	install = {
		colorscheme = { "catppuccin" },
	},

	checker = {
		enable = true,
		notify = false,
	},
	change_detection = {
		notify = false,
	},
})
