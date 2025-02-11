-- Load nvim-tree on startup
require("nvim-tree").setup()

-- Auto-open File Tree when starting Neovim
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("nvim-tree.api").tree.open()
  end,
})
