return {
  "akinsho/toggleterm.nvim",
  version = "*",
  cmd = "ToggleTerm",
  opts = {
    open_mapping = "<C-\\>",
    autochdir = false,
    float_opts = {
      border = "rounded",
      winblend = 10,
    },
  },
  keys = { "<C-\\>", "<leader>gg" },
  init = function()
    function _G.set_terminal_keymaps()
      local opts = { buffer = 0 }
      vim.keymap.set("t", "<A-esc>", [[<C-\><C-n>]], opts)
    end

    vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
  end,
  config = function(_, opts)
    require("toggleterm").setup(opts)

    local Terminal = require("toggleterm.terminal").Terminal
    local lazygit = Terminal:new({
      cmd = "lazygit",
      dir = "git_dir",
      direction = "float",
    })
    function _lazygit_toggle()
      lazygit:toggle()
    end
    function _lazygit_close()
      lazygit:close()
    end
    vim.keymap.set("n", "<leader>gg", _lazygit_toggle,  {desc = "Toggle lazygit"})
    vim.keymap.set("n", "q", _lazygit_close,  {desc = "Close lazygit"})
  end,
}

