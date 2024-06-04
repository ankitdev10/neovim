return {
	{
		"catppuccin/nvim",
		priority = 1000,
		lazy = true,
		opts = require("plugins.colorscheme.catpuccin"),
	},
	{
		"sainnhe/sonokai",
		priority = 1000,
		lazy = true,
		opts = require("plugins.colorscheme.sonokai"),
	},
	{
		"folke/tokyonight.nvim",
		priority = 1000,
		lazy = true,
		opts = require("plugins.colorscheme.tokyonight"),
	},
}
