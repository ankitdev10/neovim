local autocmd = vim.api.nvim_create_autocmd

-- Close [No Name] buffer when a real file is opened
autocmd("BufReadPost", {
    callback = function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf)
                and vim.api.nvim_buf_get_name(buf) == ""
                and vim.bo[buf].filetype == ""
                and not vim.bo[buf].modified
            then
                vim.api.nvim_buf_delete(buf, {})
            end
        end
    end,
})

autocmd("TextYankPost", {
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch",
            timeout = 80,
        })
    end,
})
