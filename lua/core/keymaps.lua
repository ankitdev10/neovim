vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- Save and Quite made easier
keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save current file" })
keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
keymap.set("n", "<leader>qa", "<cmd>qa<CR>", { desc = "Quit all" })
-- Save the current file in normal mode
keymap.set("n", "<C-s>", "<cmd>w<CR>", { desc = "Save current file in normal mode" })

-- Save the current file in insert mode
keymap.set("i", "<C-s>", "<cmd>write<CR><ESC>", { desc = "Save current file in insert mode" })

-- Window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- Tabs
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- Move lines/blocks
keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move Line Down" })
keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move Line Down" })
keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move block of line down" })
keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move block of line up" })
