-- Keybinding to Toggle File Explorer
vim.api.nvim_set_keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- Prevent Mouse Clicks from Moving Cursor
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd("nnoremap <LeftMouse> :<C-U>echo 'Mouse Click Disabled'<CR>")
  end,
})
