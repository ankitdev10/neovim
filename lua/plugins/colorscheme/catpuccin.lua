return {
	"catppuccin/nvim",
	priority = 1000,

	config = function()
		require("catppuccin").setup({
			flavour = "mocha",
			background = { light = "latte", dark = "mocha" },
			transparent_background = true,
		})
	end,
}
