require("nvim-treesitter.configs").setup({
  highlight = { enable = true },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25,
    persist_queries = false,
  }
})
