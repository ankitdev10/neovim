return {
	"Mofiqul/dracula.nvim",
	lazy = true,
	priority = 1000,

	config = function()
		require("dracula").setup({
			transparent_bg = true,
		})
	end,
}
