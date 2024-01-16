-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("neo-tree").setup({
  filesystem = {
    follow_current_file = true, -- Optional: Focus on the current file in Neo-tree
    hijack_netrw = true,

    use_libuv_file_watcher = false, -- Optional: May improve performance on WSL
    filters = {
      hide_dotfiles = false,        -- This line enables hidden files
    },
  },
})


local luasnip = require("luasnip")

luasnip.filetype_extend("javascriptreact", { "html" })

luasnip.filetype_extend("typescriptreact", { "html" })

require("luasnip/loaders/from_vscode").lazy_load()

local cmp = require('cmp')
cmp.setup {
  mapping = {
    ["<A-j>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expandable() then
        luasnip.expand()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif check_backspace() then
        fallback()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<A-k>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),

    ['<CR>'] = cmp.mapping.confirm {

      behavior = cmp.ConfirmBehavior.Replace,
      select = true
    },
    ["<A-l>"] = cmp.mapping {
      i = cmp.mapping.abort(),
      c = cmp.mapping.close()
    },
    ["<A-i>"] = cmp.mapping {
      i = cmp.mapping.complete()
    },
  },
}
