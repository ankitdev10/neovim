return {
	colorscheme = {
		default = "dracula",
		select = function()
			vim.ui.select({
				"nightly",
				"material",
				"material-darker",
				"material-lighter",
				"material-palenight",
				"material-oceanic",
				"material-deep-ocean",
				"gruvbox",
				"tokyonight",
				"tokyonight-day",
				"tokyonight-night",
				"tokyonight-moon",
				"tokyonight-storm",
				"catppuccin",
				"catppuccin-frappe",
				"catppuccin-latte",
				"catppuccin-mocha",
				"catppuccin-macchiato",
				"onedark",
				"kanagawa",
				"kanagawa-wave",
				"kanagawa-dragon",
				"kanagawa-lotus",
				"dracula",
				"dracula-soft",
				"sonokai",
			}, { prompt = "Select colorscheme" }, function(choice)
				vim.cmd.colorscheme(choice)
			end)
		end,
	},
}
