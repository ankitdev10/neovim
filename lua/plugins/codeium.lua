return {
	"Exafunction/codeium.vim",
	event = "InsertEnter",
	config = function()
		local opts = { expr = true, silent = true }
		vim.keymap.set("i", "<Tab>", function()
			return vim.fn["codeium#Accept"]()
		end, opts)
		vim.keymap.set("i", "<S-Tab>", function()
			return vim.fn["codeium#CycleCompletions"](-1)
		end, opts)
	end,
}
